# frozen_string_literal: true

require 'drb'
require_relative 'input_method'

module IrbRemote
  class CLI
    attr_reader :host, :port

    def self.run(host, port)
      new(host, port).run
    end

    def initialize(host, port)
      @host = host
      @port = port
    end

    def run
      DRb.start_service
      client = DRbObject.new_with_uri(uri)
      puts "Connected to remote session on #{uri}"
      IRB.setup(client.binding.source_location[0], argv: [])
      client.thread = Thread.current
      client.input_method = InputMethod.new(client.binding)
      client.output = $stdout
      client.stderr = $stderr
      sleep
    ensure
      DRb.stop_service
      puts 'Disconnected from remote session'
    end

    def uri
      "druby://#{host}:#{port}"
    end
  end
end
