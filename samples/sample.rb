$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'babascript/client'
require "awesome_print"

client = Babascript::Client.new "baba", {:linda => "http://localhost:3030"}
client.on :get_task do |err, tuple|
  puts err
  puts tuple
  client.close
end
