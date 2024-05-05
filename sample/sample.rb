# frozen_string_literal: true

require_relative '../lib/irb-remote'
x = 1
y = 'hello'
check_completion = 'success'

binding.irb_remote

puts "#{x} #{y} #{check_completion}"
