# frozen_string_literal: true

require_relative 'server'

module IrbRemote
  module Binding
    def irb_remote(host = IrbRemote::DEFAULT_HOST, port = IrbRemote::DEFAULT_PORT, options = {})
      IrbRemote::Server.run(self, host, port, options)
    end
    alias remote_irb irb_remote

    def eval_methods
      ::Kernel.instance_method(:methods).bind(eval('self')).call
    end

    def eval_private_methods
      ::Kernel.instance_method(:private_methods).bind(eval('self')).call
    end

    def eval_instance_variables
      ::Kernel.instance_method(:instance_variables).bind(eval('self')).call
    end

    def eval_global_variables
      ::Kernel.instance_method(:global_variables).bind(eval('self')).call
    end

    def eval_class_constants
      ::Module.instance_method(:constants).bind(eval('self.class')).call
    end
  end
end
