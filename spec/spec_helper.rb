require 'rubygems'
require 'rspec'
require 'pry'

RSpec.configure do |config|
   config.color = true
   config.tty = true
end

$LOAD_PATH.unshift File.expand_path('lib')
require 'mini_object'
include MiniObject

$LOAD_PATH.unshift File.expand_path('spec/support')

