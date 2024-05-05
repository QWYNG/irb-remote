# frozen_string_literal: true

require_relative 'client'
require 'drb'
require 'irb'

module IrbRemote
  class Server
    attr_reader :binding_object, :client, :host, :port

    def self.run(binding_object, host = DEFAULT_HOST, port = DEFAULT_PORT, options = {})
      new(binding_object, host, port, options).run
    end

    def initialize(binding_object, host = DEFAULT_HOST, port = DEFAULT_PORT, options = {})
      @host = host
      @port = port

      @binding_object = binding_object
      @options = options

      @client = IrbRemote::Client.new
      @client.binding = binding_object
    end

    def teardown
      puts '[irb-remote] Remote session terminated'

      begin
        @client.kill
      rescue DRb::DRbConnError
        puts '[irb-remote] Client already disconnected'
      ensure
        DRb.stop_service
        puts '[irb-remote] stopped'
      end
    end

    def run
      DRb.start_service uri, @client
      puts "[irb-remote] Waiting for client on #{uri}"
      client.wait
      puts '[irb-remote] Client received, starting irb session'
      IRB.setup(binding_object.source_location[0], argv: [])
      irb_workspace = IRB::WorkSpace.new(binding_object)
      $stdout = client.output
      print(irb_workspace.code_around_binding)
      IRB::Irb.new(irb_workspace, client.input_method).run
    rescue DRb::DRbConnError
      $stdout.puts '[irb-remote] Client disconnected'
    ensure
      $stdout = STDOUT
      teardown
    end

    def uri
      "druby://#{host}:#{port}"
    end
  end
end
