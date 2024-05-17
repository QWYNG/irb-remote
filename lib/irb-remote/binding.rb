# frozen_string_literal: true

require_relative 'server'

module IrbRemote
  module Binding
    def irb_remote(host = IrbRemote::DEFAULT_HOST, port = IrbRemote::DEFAULT_PORT, options = {})
      IrbRemote::Server.run(self, host, port, options)
    end
    alias remote_irb irb_remote
  end
end
