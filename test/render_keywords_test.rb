require 'test_helper'

class RenderKeywordsClass < ActionView::TestCase
  test 'simple' do
    assert_equal render_keywords, '<meta name="keywords" content="keywords" />'
  end
  
  test '@keywords' do
    @keywords = '@keywords'
    assert_equal render_keywords, '<meta name="keywords" content="@keywords" />'
    @keywords = ['@keywords', '   ', '', nil]
    assert_equal render_keywords, '<meta name="keywords" content="@keywords" />'
    ['   ', '', nil].each do |key|
      @keywords = key
      assert_equal render_keywords, ''
    end
  end
  
  test '@item' do
    @item = Item.new
    assert_equal render_keywords, '<meta name="keywords" content="item_keywords" />'
  end

  test 'opts' do
    assert_equal render_keywords(keywords: 'opts'), '<meta name="keywords" content="opts" />'
  end
end

class HelperSettings
  def self.keywords
    'keywords'
  end
end

class Item
  def keywords
    'item_keywords'
  end
end
