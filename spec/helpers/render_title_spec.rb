require 'spec_helper'

include H2ocubeRailsHelper::ActionViewExtension

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
    render_title.should == '<title>title</title>'
  end
  
  it '@title' do
    @title = '@title'
    render_title.should == '<title>@title - title</title>'
    @title = ['@title', '   ', '', nil]
    render_title.should == '<title>@title - title</title>'
  end
  
  it 'resource' do
    self.class_eval do
      def resource
        Resource.new
      end
    end
    render_title.should == '<title>Resource Name - Class Name - title</title>'
  end

  it '@_title' do
    @_title = '@_title'
    render_title.should == '<title>@_title</title>'
  end

  it 'opts' do
    render_title(title: 'opts').should == '<title>opts</title>'
  end
end
