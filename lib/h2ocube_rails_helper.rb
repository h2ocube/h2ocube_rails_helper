# coding: utf-8

require 'settingslogic'
require 'rack/mobile-detect'
require 'draper'

module H2ocubeRailsHelper
  module Rails
		class Rails::Engine < ::Rails::Engine
		  initializer 'Rack::MobileDetect' do |app|
        app.middleware.use Rack::MobileDetect
      end
		end
	end
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
  if params.has_key?(:html_class)
    if params[:html_class].class != Array
      cls.push params[:html_class].to_s
    else
      params[:html_class].each { |c| cls.push c }
    end
  end
  if request.env['X_MOBILE_DEVICE']
    cls.push 'mobile', request.env['X_MOBILE_DEVICE']
  end
  cls.compact.uniq.join ' '
end

def _title opts = {}
  return [@_title] if defined?(@_title)
  if defined?(@title)
    title = @title.class.to_s == 'Array' ? @title : [ @title.strip ]
  else
    if defined?(@item)
      if @item.respond_to?(:title) && !@item.title.blank?
        title = @item.title
      end
    end
    title ||= []
  end
  title = [ title ] if title.class.to_s != 'Array'
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

def _keywords
  if defined? @keywords
    keywords = (@keywords.class.to_s == 'Array' ? @keywords : @keywords.to_s.strip.split(/(,|，)/))
  elsif defined?(@item) && @item.respond_to?(:keywords) && !@item.keywords.blank?
    keywords = @item.keywords.strip.split(/(,|，)/)
  else
    keywords = HelperSettings.keywords.strip.split(/(,|，)/)
  end
  keywords.compact.map{ |k| k = k.gsub(/(,|，)/, '').strip; k.blank? ? nil : k }.compact.uniq
end

def render_keywords opts = {}
  return '' if _keywords.length == 0
  "<meta name=\"keywords\" content=\"#{_keywords.join(',')}\" />".html_safe
end

def _description
  if defined? @description
    description = @description
  elsif defined?(@item) && @item.respond_to?(:description) && !@item.description.blank?
    description = @item.description
  else
    description = HelperSettings.description
  end
  description.to_s.strip
end

def render_description opts = {}
  return '' if _description == ''
  "<meta name=\"description\" content=\"#{_description}\" />".html_safe
end

def render_canonical opts = {}
  defined?(@canonical) && !@canonical.blank? ? "<link rel=\"canonical\" href=\"#{@canonical}\" />".html_safe : ''
end

def render_seo opts = {}
  render_title(opts) << render_canonical(opts) << render_keywords(opts) << render_description(opts) << render_ga(opts) << csrf_meta_tags
end

def render_ga opts = {}
  ("<script>_gaq=[['_setDomainName', '#{HelperSettings.domain}'],['_trackPageview'],['_trackPageLoadTime']];</script>" << Garelic.monitoring(opts[:ga] || HelperSettings.ga)).html_safe if defined?(Garelic)# && !Rails.env.development?
end
