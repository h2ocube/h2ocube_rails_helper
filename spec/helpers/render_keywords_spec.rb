require 'spec_helper'

class HelperSettings
  def self.keywords
    'keywords'
  end
end

class Item
  def keywords
    'item，item_keywords'
  end
end

describe 'render_keywords' do
  it 'simple' do
  render_keywords.should == '<meta name="keywords" content="keywords" />'
  end
  
  it '@keywords' do
    @keywords = '@keywords'
    render_keywords.should == '<meta name="keywords" content="@keywords" />'
    @keywords = ['@keywords', '   ', '', nil]
    render_keywords.should == '<meta name="keywords" content="@keywords" />'
    ['   ', '', nil].each do |key|
      @keywords = key
      render_keywords.should == ''
    end
  end
  
  it '@item' do
    @item = Item.new
    render_keywords.should == '<meta name="keywords" content="item,item_keywords" />'
  end

  it 'opts' do
    render_keywords(keywords: 'opts,a,b,c').should == '<meta name="keywords" content="opts,a,b,c" />'
  end
end
