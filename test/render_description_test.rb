require 'test_helper'

class RenderDescriptionClass < ActionView::TestCase
  test 'simple' do
    assert_equal render_description, '<meta name="description" content="description" />'
  end
  
  test '@description' do
    @description = '@description'
    assert_equal render_description, '<meta name="description" content="@description" />'
    ['   ', '', nil].each do |desc|
      @description = desc
      assert_equal render_description, ''
    end
  end
  
  test '@item' do
    @item = Item.new
    assert_equal render_description, '<meta name="description" content="item_description" />'
  end

  test 'opts' do
    assert_equal render_description(description: 'opts'), '<meta name="description" content="opts" />'
  end
end

class HelperSettings
  def self.description
    'description'
  end
end

class Item
  def description
    'item_description'
  end
end
