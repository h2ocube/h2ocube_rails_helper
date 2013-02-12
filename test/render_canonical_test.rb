require 'test_helper'

class RenderCanonicalClass < ActionView::TestCase
  test 'simple' do
    assert_equal render_canonical, ''
  end
  
  test '@canonical' do
    @canonical = '@canonical'
    assert_equal render_canonical, '<link rel="canonical" href="@canonical" />'
    ['   ', '', nil].each do |desc|
      @canonical = desc
      assert_equal render_canonical, ''
    end
  end
end
