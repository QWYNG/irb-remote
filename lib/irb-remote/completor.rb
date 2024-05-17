# frozen_string_literal: true

require 'irb'

module IrbRemote
  class Completor < IRB::RegexpCompletor
    using(Module.new do
      refine ::DRb::DRbObject do
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
    end)

    def eval(expr, bind)
      bind.eval(expr)
    end
  end
end
