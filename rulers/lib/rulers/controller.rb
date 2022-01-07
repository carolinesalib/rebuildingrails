require "erubis"
require "rulers/file_model"
require "rack/request"

module Rulers
  class Controller
    include Rulers::Model

    def initialize(env)
      @env = env
    end

    def env
      @env
    end

    def request
      @request ||= Rack::Request.new(@env)
    end

    def params
      request.params
    end

    def response(text, status = 200, headers = {})
      raise "Already responded!" if @response
      a = [text].flatten
      @response = Rack::Response.new(a, status, headers)
    end

    def get_response # Only for rulers
      @response
    end

    def default_view_filename(action)
      File.join "app", "views", controller_name, "#{action}.html.erb" 
    end

    def render(view_name, locals = {})
      filename = File.join "app", "views", controller_name, "#{view_name}.html.erb"
      template = File.read filename
      eruby = Erubis::Eruby.new(template)
      result = eruby.result locals.merge(
        env: env,
        controller_name: controller_name,
        action_name: view_name,
      )
      response(result)
      result
    end

    def controller_name
      klass = self.class
      klass = klass.to_s.gsub /Controller$/, ""
      Rulers.to_underscore klass
    end
  end
end
