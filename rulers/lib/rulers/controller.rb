require "erubis"
require "rulers/file_model"
require "rack/request"

module Rulers
  class Controller
    include Rulers::Model

    def initialize(env)
      @env = env
      @routing_params = {}
    end

    def dispatch(action, routing_params = {})
      @routing_params = routing_params
      text = send(action)
      r = get_response
      if r
        [r.status, r.headers, [r.body].flatten]
      else
        [200, {"Content-Type" => "text/html"}, [text].flatten]
      end
    end

    def self.action(act, rp = {})
      proc { |e| new(e).dispatch(act, rp) }
    end

    def env
      @env
    end

    def request
      @request ||= Rack::Request.new(@env)
    end

    def params
      request.params.merge(@routing_params)
    end

    def response(text, status = 200, headers = {})
      raise "Already responded!" if @response
      a = [text].flatten
      @response = Rack::Response.new(a, status, headers)
    end

    def get_response # Only for rulers
      @response
    end

    def instance_hash
      h = {}
      instance_variables.each do |i|
        h[i] = instance_variable_get(i)
      end
      h
    end

    def render(view_name, locals = {})
      filename = File.join "app", "views", controller_name, "#{view_name}.html.erb"
      template = File.read filename
      v = View.new
      v.set_vars(instance_hash)
      v.evaluate(template, locals)
    end

    def controller_name
      klass = self.class
      klass = klass.to_s.gsub /Controller$/, ""
      Rulers.to_underscore klass
    end
  end
end
