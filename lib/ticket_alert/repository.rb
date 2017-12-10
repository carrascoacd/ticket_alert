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
      if id == :all
        @messages.values
      else
        @messages[id]
      end
    end

    def add objects
      if objects.is_a? Array
        objects.each do |m|
          @messages[m.identifier] = m
        end
      else
        @messages[objects.identifier] = objects
      end
    end

    def save
      @redis_client.set(KEY, Hash[@messages.collect{|k,v| [k, v.to_h]}].to_json)
    end

    def delete id
      if id == :all
        @messages = {}
      else
        @messages.delete id
      end
    end

    def read
      @messages = JSON.parse((@redis_client.get(KEY) || "{}"), symbolize_names: true)
    end

  end

end