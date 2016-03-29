require 'spec_helper'

class HelperSettings
  def self.title
    'title'
  end
end

class ResourceModelName
  def human
    'Class Name'
  end
end

class Resource
  def title
    'Resource Name'
  end

  def self.model_name
    ResourceModelName.new
  end
end

describe 'render_title' do
  it 'simple' do
    expect(render_title).to eq('<title>title</title>')
  end

  it '@title' do
    @title = '@title'
    expect(render_title).to eq('<title>@title - title</title>')
    @title = ['@title', '   ', '', nil]
    expect(render_title).to eq('<title>@title - title</title>')
  end

  it 'resource' do
    self.class_eval do
      def resource
        Resource.new
      end
    end
    expect(render_title).to eq('<title>Resource Name - Class Name - title</title>')
  end

  it '@_title' do
    @_title = '@_title'
    expect(render_title).to eq('<title>@_title</title>')
  end

  it 'opts' do
    expect(render_title(title: 'opts')).to eq('<title>opts</title>')
  end
end
