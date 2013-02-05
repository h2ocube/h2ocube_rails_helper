require 'test_helper'

class RenderTitleClass < ActionView::TestCase
  test 'simple' do
    assert_equal render_title, '<title>title</title>'
  end
  
  test '@title' do
    @title = '@title'
    assert_equal render_title, '<title>@title - title</title>'
    @title = ['@title', '   ', '', nil]
    assert_equal render_title, '<title>@title - title</title>'
  end
  
  test '@item' do
    @item = Item.new
    assert_equal render_title, '<title>item_title - title</title>'
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

class Item
  def title
    'item_title'
  end
end
