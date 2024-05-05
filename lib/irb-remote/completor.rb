# frozen_string_literal: true

require 'irb'

module IrbRemote
  class Completor < IRB::RegexpCompletor
    def eval(expr, bind)
      bind.eval(expr)
    end
  end
end
