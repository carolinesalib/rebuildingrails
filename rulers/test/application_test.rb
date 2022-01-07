# require_relative is a require that check from this file's direct instead load path
require_relative "test_helper"

class TestController < Rulers::Controller
  def index
    "Hello!" # Not rendering a view
  end
end

class TestApp < Rulers::Application
  def get_controller_and_action(env)
    [TestController, "index"]
  end
end

class RulersAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    TestApp.new
  end

  def test_request
    err = assert_raises { get "/example/route" }
    assert_match "No such file or directory @ rb_sysopen - app/views/test/index.html.erb", err.message
  end
end
