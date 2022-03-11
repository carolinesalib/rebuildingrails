module Rulers
  class View
    def set_vars(instance_vars)
      instance_vars.each do |name, value|
        instance_variable_set(name, value)
      end
    end

    def evaluate(template, locals = {})
      eruby = Erubis::Eruby.new(template)
      eruby.result(locals)
    end

    def h(str)
      CGI.escape(str)
    end
  end
end
