require 'spec_helper'

class Item
  def description
    'item_description'
  end
end

describe 'render_description' do
  before do
    Rails.application.secrets[:description] = 'description'
  end

  it 'simple' do
    expect(render_description).to eq('<meta name="description" content="description" />')
  end

  it '@description' do
    @description = '@description'
    expect(render_description).to eq('<meta name="description" content="@description" />')
    ['   ', '', nil].each do |desc|
      @description = desc
      expect(render_description).to eq('')
    end
  end

  it '@item' do
    @item = Item.new
    expect(render_description).to eq('<meta name="description" content="item_description" />')
  end

  it 'opts' do
    expect(render_description(description: 'opts')).to eq('<meta name="description" content="opts" />')
  end
end
