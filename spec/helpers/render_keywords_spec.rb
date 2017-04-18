require 'spec_helper'

class Item
  def keywords
    'item，item_keywords'
  end
end

describe 'render_keywords' do
  before do
    Rails.application.secrets[:keywords] = 'keywords'
  end

  it 'simple' do
    expect(render_keywords).to eq('<meta name="keywords" content="keywords" />')
  end

  it '@keywords' do
    @keywords = '@keywords'
    expect(render_keywords).to eq('<meta name="keywords" content="@keywords" />')
    @keywords = ['@keywords', '   ', '', nil]
    expect(render_keywords).to eq('<meta name="keywords" content="@keywords" />')
    ['   ', '', nil].each do |key|
      @keywords = key
      expect(render_keywords).to eq('')
    end
  end

  it '@item' do
    @item = Item.new
    expect(render_keywords).to eq('<meta name="keywords" content="item,item_keywords" />')
  end

  it 'opts' do
    expect(render_keywords(keywords: 'opts,a,b,c')).to eq('<meta name="keywords" content="opts,a,b,c" />')
  end
end
