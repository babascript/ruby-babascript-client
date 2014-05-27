$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'babascript/client'
require "awesome_print"

flag = false
clients = []
k = 0
for i in 0..10
  c = Babascript::Client.new "baba", {:linda => "http://localhost:3030"}
  c.on :get_task do |data|
    j = Random.rand 4
    a = data[:list][j]
    c.return_value a
    k += 1
    if k == 9
      flag = true
    end
  end
  clients.push c
end

loop do
  sleep 1
  break if flag
end
