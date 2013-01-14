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

def _title
  if defined?(@title)
    title = @title.class.to_s == 'Array' ? @title : [ @title.strip ]
  else
    if defined?(@item)
      if @item.respond_to?(:seo_title) && !@item.seo_title.blank?
        title = @item.seo_title
      elsif @item.respond_to?(:title) && !@item.title.blank?
        title = @item.title
      elsif @item.respond_to?(:name) && !@item.name.blank?
        title = @item.name
      end
    end
    title ||= []
  end
  title = [ title ] if title.class.to_s != 'Array'
  title.push HelperSettings.title
  title.map{ |t| t.strip }
end

def render_title
  "<title>#{_title.join(' - ')}</title>".html_safe
end

def _keywords
  if defined? @keywords
    keywords = (@keywords.class.to_s == 'Array' ? @keywords : @keywords.strip.split(/(,|，)/))
  elsif defined?(@item) && @item.respond_to?(:seo_keywords) && !@item.seo_keywords.blank?
    keywords = @item.seo_keywords.strip.split(/(,|，)/)
  else
    keywords = HelperSettings.keywords.strip.split(/(,|，)/)
  end
  keywords.map{ |k| k = k.gsub(/(,|，)/, '').strip; k.blank? ? nil : k }.compact.uniq
end

def render_keywords
  "<meta name=\"keywords\" content=\"#{_keywords.join(',')}\" />".html_safe
end

def _description
  if defined? @description
    description = @description
  elsif defined?(@item) && @item.respond_to?(:seo_description) && !@item.seo_description.blank?
    description = @item.seo_description
  else
    description = HelperSettings.description
  end
  description.strip
end

def render_description
  "<meta name=\"description\" content=\"#{_description}\" />".html_safe
end

def render_canonical
  defined?(@canonical) && !@canonical.blank? ? "<link rel=\"canonical\" href=\"#{@canonical}\" />".html_safe : ''
end

def render_seo
  render_title << render_canonical << render_keywords << render_description << render_ga << csrf_meta_tags
end

def render_ga
  ("<script>_gaq=[['_setDomainName', '#{HelperSettings.domain}'],['_trackPageview'],['_trackPageLoadTime']];</script>" << Garelic.monitoring(HelperSettings.ga)).html_safe if defined?(Garelic) && Rails.env.production?
end
