require 'test_helper'

class RenderGaClass < ActionView::TestCase
  test 'simple' do
    assert render_ga.include?('ga_code')
    assert render_ga(ga: '123').include?('123')
  end
end

class HelperSettings
  def self.title
    'title'
  end
  
  def self.keywords
    'keywords'
  end
  
  def self.description
    'description'
  end
  
  def self.ga
    'ga_code'
  end
  
  def self.domain
    'domain'
  end
end
