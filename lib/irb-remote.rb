# frozen_string_literal: true

require_relative 'irb-remote/version'
require_relative 'irb-remote/binding'

module IrbRemote
  class Error < StandardError; end

  DEFAULT_HOST = ENV['IRB_REMOTE_DEFAULT_HOST'] || '127.0.0.1'
  DEFAULT_PORT = ENV['IRB_REMOTE_DEFAULT_PORT'] || 9876
end

Binding.prepend(IrbRemote::Binding)
