require "babascript/client/version"
require "linda-socket.io-client"
require "event_emitter"
require 'awesome_print'

module Babascript
  class Client
    include EventEmitter

    def initialize(name, options={})
      @name = name
      @api = options[:linda] || "http://linda.babascript.org"
      @tasks = []
      @id = @get_id

      @linda = Linda::SocketIO::Client.connect @api
      @ts = @linda.tuplespace @name
      @flag = false
      this = self
      @linda.io.on :connect do
        this.next
        this.broadcast
        this.unicast
      end
      while !@flag do
        if !@flag
          sleep 1
        end
      end
    end

    def next
      if @tasks.length > 0
        task = @tasks[0]
        emit :get_task, task
      else
        p "next"
        tuple = {
          "baba" => "script",
          "type" => "eval"
        }
        this = self
        @ts.take tuple do |err, tuple|
          ap tuple
          ap get_task
          this.get_task err, tuple
        end
      end
    end

    def broadcast
      tuple = {
        :baba => "script",
        :type => "broadcast"
      }
      @ts.read tuple do |err, tuple|
        get_task err, tuple
        @group.watch tuple do |err, tuple|
          get_task err, tuple
        end
      end
    end

    def return_value(value, options={})
      task = @tasks.shift
      tuple = {
        :baba => "script",
        :type => "return",
        :value => value,
        :cid => task.cid,
        :worker  =>  @name,
        :options => options,
        :name => @ts.name,
        :_task => task
      }
      @ts.write tuple
      @next
    end

    def get_task(err, tuple)
      if err
        return err
      end
      @tasks.push tuple.data
      # @emit :get_  task, tuple.data
    end

    def get_id
      "#{Random.rand 10000}_#{Random.rand 10000}"
    end

    def close
      @flag = true
    end
  end
end
