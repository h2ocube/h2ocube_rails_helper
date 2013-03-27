# coding: utf-8

require 'settingslogic'
require 'rack/mobile-detect'

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

def _keywords opts = {}
  if defined? @keywords
    keywords = @keywords
  elsif defined?(@item) && @item.respond_to?(:keywords) && !@item.keywords.blank?
    keywords = @item.keywords.strip.split(/(,|，)/)
  else
    keywords = opts.has_key?(:keywords) ? opts[:keywords] : HelperSettings.keywords
  end
  [keywords].flatten.compact.map{ |k| k.strip.split(/(,|，)/) }.flatten.map{ |k| k.gsub(/(,|，)/, '').blank? ? nil : k }.compact.uniq
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
  ga = opts[:ga] || HelperSettings.ga
  if defined?(Garelic)
    return ("<script>_gaq=[['_trackPageview'],['_trackPageLoadTime']];</script>" << Garelic.monitoring(ga)).html_safe
  else
    return "<script>var _gaq=[['_setAccount','#{ga}'],['_trackPageview'],['_trackPageLoadTime']];(function(){var ga=document.createElement('script');ga.type='text/javascript';ga.async=true;ga.src=('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';var s=document.getElementsByTagName('script')[0];s.parentNode.insertBefore(ga,s);})();</script>"
  end
end