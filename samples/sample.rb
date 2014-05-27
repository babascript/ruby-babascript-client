$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'babascript/client'
require "awesome_print"

client = Babascript::Client.new "baba", {:linda => "http://localhost:3030"}

flag = false
client.on :get_task do |data|
  puts data[:key]
  client.return_value true
  flag = true
end

loop do
  sleep 1
  break if flag
end
