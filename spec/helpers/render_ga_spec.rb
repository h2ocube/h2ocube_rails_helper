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
    expect(render_ga).to include('ga_code')
  end

  it 'with option' do
    expect(render_ga(ga: '123')).to include('123')
  end

  it 'with nil' do
    expect(render_ga(ga: nil)).to eq('')
  end
end
