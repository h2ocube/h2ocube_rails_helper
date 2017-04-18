require 'spec_helper'

describe 'render_ga' do
  before do
    Rails.application.secrets[:title] = 'title'
    Rails.application.secrets[:keywords] = 'keywords'
    Rails.application.secrets[:description] = 'description'
    Rails.application.secrets[:ga] = 'ga_code'
    Rails.application.secrets[:domain] = 'domain'
  end

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
