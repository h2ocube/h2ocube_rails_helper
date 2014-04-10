require 'spec_helper'

describe 'render_canonical' do
  it 'simple' do
    render_canonical.should == ''
  end
  
  it '@canonical' do
    @canonical = '@canonical'
    render_canonical.should == '<link rel="canonical" href="@canonical" />'
    ['   ', '', nil].each do |desc|
      @canonical = desc
      render_canonical.should == ''
    end
  end
end
