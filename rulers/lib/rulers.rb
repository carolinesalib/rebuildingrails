# frozen_string_literal: true
require "rulers/array"
require_relative "rulers/version"
require "rulers/routing"
require "rulers/util"
require "rulers/dependencies"
require "rulers/controller"
require "rulers/view"
require "rulers/file_model"

module Rulers
  class Application
    def call(env)
      if env["PATH_INFO"] == "/favicon.ico"
        return [404, {"Content-Type" => "text/html"}, []]
      elsif env["PATH_INFO"] == "/"
        file = File.open("public/index.html")
        return [200, {"Content-Type" => "text/html"}, [file.read]]
      end

      rack_app = get_rack_app(env)
      rack_app.call(env)
      # klass, act = get_controller_and_action(env)
      # controller = klass.new(env)
      # text = controller.send(act)
      # r = controller.get_response

      # if r
      #   [r.status, r.headers, [r.body].flatten]
      # else
      #   [200, {'Content-Type' => 'text/html'}, [text]]
      # end
    end
  end
end
