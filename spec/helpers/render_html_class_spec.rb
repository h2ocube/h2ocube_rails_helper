require 'spec_helper'

describe 'render_html_class' do
  def params
    @params || {}
  end

  def params=(data)
    @params = data
  end

  class Request
    def env
      @env ||= {}
      @env
    end

    def env=(data)
      @env = data
    end
  end

  def request
    @request ||= Request.new
  end

  it 'simple params' do
    self.params = {
      controller: 'controller',
      action: 'action'
    }
    cls = render_html_class.split ' '
    expect(cls).to include('controller')
    expect(cls).to include('action')
    expect(cls).to include('controller_action')
  end

  it 'module controller' do
    self.params = {
      controller: 'module/controller',
      action: 'action'
    }
    cls = render_html_class.split ' '
    expect(cls).to include('module_controller')
    expect(cls).to include('controller')
    expect(cls).to include('action')
    expect(cls).to include('module_controller_action')
  end

  it 'addition html class' do
    self.params = {
      controller: 'controller',
      action: 'action',
      html_class: 'addition'
    }
    cls = render_html_class.split ' '
    expect(cls).to include('controller')
    expect(cls).to include('action')
    expect(cls).to include('controller_action')
    expect(cls).to include('addition')
  end

  it 'mobile' do
    self.params = {
      controller: 'controller',
      action: 'action'
    }
    request.env['HTTP_USER_AGENT'] = 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_2_1 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8C148 Safari/6533.18.5'
    cls = render_html_class.split ' '

    expect(cls).to include('controller')
    expect(cls).to include('action')
    expect(cls).to include('controller_action')
    expect(cls).to include('mobile')
    expect(cls).to include('iphone')
  end
end
