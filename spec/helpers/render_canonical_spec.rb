require 'spec_helper'

describe 'render_canonical' do
  it 'simple' do
    expect(render_canonical).to eq('')
  end

  it '@canonical' do
    @canonical = '@canonical'
    expect(render_canonical).to eq('<link rel="canonical" href="@canonical" />')
    ['   ', '', nil].each do |desc|
      @canonical = desc
      expect(render_canonical).to eq('')
    end
  end
end
