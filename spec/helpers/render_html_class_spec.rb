require 'spec_helper'

describe 'render_html_class' do
	def params
		@params || {}
	end

	def params= data
		@params = data
	end

	class Request
		def env
			@env || {}
		end

		def env= data
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
		cls.should include('controller')
		cls.should include('action')
		cls.should include('controller_action')
	end

	it 'module controller' do
		self.params = {
			controller: 'module/controller',
			action: 'action'
		}
		cls = render_html_class.split ' '
		cls.should include('module_controller')
		cls.should include('controller')
		cls.should include('action')
		cls.should include('module_controller_action')
	end

	it 'addition html class' do
		self.params = {
			controller: 'controller',
			action: 'action',
			html_class: 'addition'
		}
		cls = render_html_class.split ' '
		cls.should include('controller')
		cls.should include('action')
		cls.should include('controller_action')
		cls.should include('addition')
	end

	it 'mobile' do
		self.params = {
			controller: 'controller',
			action: 'action'
		}
		self.request.user_agent = 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_0 like Mac OS X; en-us) AppleWebKit/420.1 (KHTML, like Gecko) Version/3.0 Mobile/1A542a Safari/419.3'
		cls = render_html_class.split ' '

		cls.should include('controller')
		cls.should include('action')
		cls.should include('controller_action')
		cls.should include('mobile')
		cls.should include('iphone')
	end
end
