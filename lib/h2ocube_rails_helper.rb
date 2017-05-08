require 'browser'

module Browser
  class Base
    def wechat?
      !(ua =~ /MicroMessenger/i).nil?
    end

    def mobile?
      !ua.blank? && (device.mobile? || device.tablet?)
    end

    def desktop?
      !ua.blank? && !device.mobile? && !device.tablet?
    end

    def meta
      Meta.constants.each_with_object(Set.new) do |meta_name, meta|
        meta_class = Meta.const_get(meta_name)
        meta.merge(meta_class.new(self).to_a)
      end.to_a
    end

    alias to_a meta
  end

  class Device
    alias _detect_mobile detect_mobile?

    def detect_mobile?
      !ua.blank? && _detect_mobile
    end
  end

  module Meta
    class Wechat < Base
      def meta
        'wechat' if browser.wechat?
      end
    end

    class Desktop < Base
      def meta
        'desktop' if browser.desktop?
      end
    end

    class Tablet < Base
      def meta
        'tablet mobile' if browser.device.tablet?
      end
    end
  end
end

def rails_secrets
  @_secrest ||= Rails.application.secrets.deep_symbolize_keys
end

module H2ocubeRailsHelper
  module ActionView
    module Helpers
      def escape(text)
        CGI.escapeHTML text
      end

      def unescape(text)
        CGI.unescapeHTML text
      end

      def browser
        @_browser ||= Browser.new request.env['HTTP_USER_AGENT'], accept_language: request.env['HTTP_ACCEPT_LANGUAGE']
      end

      def render_html_class
        cls = []
        if params[:controller].include?('/')
          cls.push params[:controller].gsub('/', '_')
          params[:controller].split('/').each { |c| cls.push c }
        else
          cls.push params[:controller]
        end

        cls.push params[:action]
        cls.push cls[0] + '_' + params[:action]

        if params.key?(:html_class)
          if params[:html_class].class != Array
            cls.push params[:html_class].to_s
          else
            params[:html_class].each { |c| cls.push c }
          end
        end

        cls.push browser.to_s

        cls.compact.uniq.join ' '
      end

      def _title(opts = {})
        return [@_title] if defined?(@_title)
        if defined?(@title) && !@title.blank?
          title = @title.is_a?(Array) ? @title : [ @title.to_s ]
        else
          begin
            title = [resource.title, resource.class.model_name.human] if defined?(resource) && resource.respond_to?(:title) && resource.class.respond_to?(:model_name)
          rescue
          end

          title ||= []
        end

        if opts.key? :title
          title.push opts[:title]
        else
          title.push rails_secrets[:title]
        end
        title.compact.map { |t| t = t.strip; t == '' ? nil : t }.compact
      end

      def _render_title(opts = {})
        strip_tags _title(opts).join(' - ')
      end

      def render_title(opts = {})
        "<title>#{_render_title opts}</title>".html_safe
      end

      def _keywords(opts = {})
        if defined? @keywords
          keywords = @keywords
        elsif defined?(@item) && @item.respond_to?(:keywords) && !@item.keywords.blank?
          keywords = @item.keywords.strip.split(/(,|，)/)
        else
          keywords = opts.key?(:keywords) ? opts[:keywords] : rails_secrets[:keywords]
        end
        [keywords].flatten.compact.map{ |k| k.to_s.strip.split(/(,|，)/) }.flatten.map { |k| k.gsub(/(,|，)/, '').blank? ? nil : k }.compact.uniq
      end

      def _render_keywords(opts = {})
        strip_tags _keywords(opts).join(',')
      end

      def render_keywords(opts = {})
        return '' if _keywords.blank?
        "<meta name=\"keywords\" content=\"#{_render_keywords opts}\" />".html_safe
      end

      def _description(opts = {})
        if defined? @description
          description = @description
        elsif defined?(@item) && @item.respond_to?(:description) && !@item.description.blank?
          description = @item.description
        else
          description = opts.key?(:description) ? opts[:description] : rails_secrets[:description]
        end
        strip_tags description.to_s.strip
      end

      def render_description(opts = {})
        return '' if _description == ''
        "<meta name=\"description\" content=\"#{_description(opts)}\" />".html_safe
      end

      def render_canonical(opts = {})
        !@canonical.blank? ? "<link rel=\"canonical\" href=\"#{@canonical}\" />".html_safe : ''
      end

      def render_seo(opts = {})
        render_title(opts) << render_canonical(opts) << render_keywords(opts) << render_description(opts) << render_ga(opts) << csrf_meta_tags
      end

      def render_ga(opts = {})
        return '' if Rails.env.development?
        ga = opts.key?(:ga) ? opts[:ga] : rails_secrets[:ga]
        domain = opts.key?(:domain) ? opts[:domain] : rails_secrets[:domain]
        return '' if ga.nil?
        "<script>(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','//www.google-analytics.com/analytics.js','ga');ga('create', '#{ga}', '#{domain}');ga('send', 'pageview');</script>".html_safe
      end

      private

      def strip_tags(text)
        Rails::Html::FullSanitizer.new.sanitize text
      end
    end
  end

  class Railtie < ::Rails::Railtie
    initializer 'h2ocube_rails_helper' do
      ActiveSupport.on_load :action_view do
        include H2ocubeRailsHelper::ActionView::Helpers
      end
    end
  end
end
