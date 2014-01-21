require 'test_helper'

class RenderTitleClass < ActionView::TestCase
  test 'simple' do
    self.class_eval do
      undef_method :resource
    end
    assert_equal render_title, '<title>title</title>'
  end
  
  test '@title' do
    @title = '@title'
    assert_equal render_title, '<title>@title - title</title>'
    @title = ['@title', '   ', '', nil]
    assert_equal render_title, '<title>@title - title</title>'
  end
  
  test 'resource' do
    def resource
      Resource.new
    end

    assert_equal render_title, '<title>Resource Name - Class Name - title</title>'
  end

  test '@_title' do
    @_title = '@_title'
    assert_equal render_title, '<title>@_title</title>'
  end

  test 'opts' do
    assert_equal render_title(title: 'opts'), '<title>opts</title>'
  end
end

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
