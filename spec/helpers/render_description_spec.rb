require 'spec_helper'

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

describe 'render_description' do
  it 'simple' do
    render_description.should == '<meta name="description" content="description" />'
  end
  
  it '@description' do
    @description = '@description'
    render_description.should == '<meta name="description" content="@description" />'
    ['   ', '', nil].each do |desc|
      @description = desc
      render_description.should == ''
    end
  end
  
  it '@item' do
    @item = Item.new
    render_description.should == '<meta name="description" content="item_description" />'
  end

  it 'opts' do
    render_description(description: 'opts').should == '<meta name="description" content="opts" />'
  end
end
