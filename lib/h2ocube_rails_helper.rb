require 'settingslogic'
require 'browser'

module H2ocubeRailsHelper
  module ActionViewExtension
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

      if params.has_key?(:html_class)
        if params[:html_class].class != Array
          cls.push params[:html_class].to_s
        else
          params[:html_class].each { |c| cls.push c }
        end
      end

      cls.push Browser.new(accept_language: request.headers['Accept-Language'], ua: request.headers['User-Agent']).to_s

      cls.compact.uniq.join ' '
    end

    def _title opts = {}
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

      if opts.has_key? :title
        title.push opts[:title]
      else
        title.push HelperSettings.title
      end
      title.compact.map{ |t| t = t.strip; t == '' ? nil : t }.compact
    end

    def render_title opts = {}
      "<title>#{_title(opts).join(' - ')}</title>".html_safe
    end

    def _keywords opts = {}
      if defined? @keywords
        keywords = @keywords
      elsif defined?(@item) && @item.respond_to?(:keywords) && !@item.keywords.blank?
        keywords = @item.keywords.strip.split(/(,|，)/)
      else
        keywords = opts.has_key?(:keywords) ? opts[:keywords] : HelperSettings.keywords
      end
      [keywords].flatten.compact.map{ |k| k.to_s.strip.split(/(,|，)/) }.flatten.map{ |k| k.gsub(/(,|，)/, '').blank? ? nil : k }.compact.uniq
    end

    def render_keywords opts = {}
      return '' if _keywords.length == 0
      "<meta name=\"keywords\" content=\"#{_keywords(opts).join(',')}\" />".html_safe
    end

    def _description opts = {}
      if defined? @description
        description = @description
      elsif defined?(@item) && @item.respond_to?(:description) && !@item.description.blank?
        description = @item.description
      else
        description = opts.has_key?(:description) ? opts[:description] : HelperSettings.description
      end
      description.to_s.strip
    end

    def render_description opts = {}
      return '' if _description == ''
      "<meta name=\"description\" content=\"#{_description(opts)}\" />".html_safe
    end

    def render_canonical opts = {}
      defined?(@canonical) && !@canonical.blank? ? "<link rel=\"canonical\" href=\"#{@canonical}\" />".html_safe : ''
    end

    def render_seo opts = {}
      render_title(opts) << render_canonical(opts) << render_keywords(opts) << render_description(opts) << render_ga(opts) << csrf_meta_tags
    end

    def render_ga opts = {}
      return '' if Rails.env.development?
      ga = opts.has_key?(:ga) ? opts[:ga] : HelperSettings.ga
      domain = opts.has_key?(:domain) ? opts[:domain] : HelperSettings.domain
      return '' if ga.nil?
      return "<script>(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','//www.google-analytics.com/analytics.js','ga');ga('create', '#{ga}', '#{domain}');ga('send', 'pageview');</script>".html_safe
    end
  end

  class Railtie < ::Rails::Railtie
    initializer 'h2ocube_rails_helper' do
      ActiveSupport.on_load(:action_view) do
        ::ActionView::Base.send :include, H2ocubeRailsHelper::ActionViewExtension
      end
    end
  end
end


