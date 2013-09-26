require 'test_helper'

class RenderHtmlClass < ActionView::TestCase
	test 'simple params' do
		self.params = {
			controller: 'controller',
			action: 'action'
		}
		cls = render_html_class.split ' '
		assert cls.include?('controller')
		assert cls.include?('action')
		assert cls.include?('controller_action')
	end

	test 'module controller' do
		self.params = {
			controller: 'module/controller',
			action: 'action'
		}
		cls = render_html_class.split ' '
		assert cls.include?('module_controller')
		assert cls.include?('controller')
		assert cls.include?('action')
		assert cls.include?('module_controller_action')
	end

	test 'addition html class' do
		self.params = {
			controller: 'controller',
			action: 'action',
			html_class: 'addition'
		}
		cls = render_html_class.split ' '
		assert cls.include?('controller')
		assert cls.include?('action')
		assert cls.include?('controller_action')
		assert cls.include?('addition')
	end

	test 'mobile' do
		self.params = {
			controller: 'controller',
			action: 'action'
		}
		self.request.user_agent = 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_0 like Mac OS X; en-us) AppleWebKit/420.1 (KHTML, like Gecko) Version/3.0 Mobile/1A542a Safari/419.3'
		cls = render_html_class.split ' '

		assert cls.include?('controller')
		assert cls.include?('action')
		assert cls.include?('controller_action')
		assert cls.include?('mobile')
		assert cls.include?('iPad')
	end

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

end
