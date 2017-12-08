require 'redis'
require "json"

module TicketAlert

  class Repository

    KEY = "messages_to_track"

    def initialize
      @redis_client = Redis.new(url: ENV['REDIS_URL'])
      @messages = {}  
    end

    def get id
      messages_to_parse = []
      if id == :all
        messages_to_parse = @messages
      else
        messages_to_parse << @messages[id]
      end
      messages_to_parse.collect{ |m| TicketAlert::Message.new date: TODO continue }
    end

    def add messages
      if messages.is_a? Array
        messages.each do |m|
          @messages[m.id] = m.to_h
        end
      else
        @messages[messages.id] = messages.to_h
      end
    end

    def save
      @redis_client.set(KEY, messages.to_json)
    end

    def delete id
      if id == :all
        @messages = {}
      else
        del @messages[id]
      end
    end

    def read
      @messages = JSON.parse((@redis_client.get(KEY) || "{}"), symbolize_names: true)
    end

  end

end