require 'spec_helper'

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

describe 'render_ga' do
  it 'default' do
    render_ga.include?('ga_code').should be_true
  end

  it 'with option' do
    render_ga(ga: '123').include?('123').should be_true
  end

  it 'with nil' do
    render_ga(ga: nil).should == ''
  end
end

