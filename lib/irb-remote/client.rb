# frozen_string_literal: true

module IrbRemote
  class Client
    attr_accessor(:input_method, :output, :stderr, :thread, :binding)

    def wait
      sleep 0.01 until thread && input_method && output && stderr
    end

    def kill
      thread.run
    end
  end
end
