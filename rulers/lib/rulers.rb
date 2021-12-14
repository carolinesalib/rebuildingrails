# frozen_string_literal: true
require "rulers/array"
require_relative "rulers/version"
require "rulers/routing"
require "rulers/util"
require "rulers/dependencies"
require "rulers/controller"
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

      klass, act = get_controller_and_action(env)
      controller = klass.new(env)

      begin
        text = controller.send(act)
      rescue
        # Without this error interception we would see rack's default fancy error page
        # with stack trace - Only on development mode though
        # return [500, {"Content-Type" => "text/html"}, ["Oh crap!!"]]
      end

      [200, {"Content-Type" => "text/html"}, [text]]
    end
  end
end
