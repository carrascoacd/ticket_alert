require 'redis'
require "json"

module TicketAlert

  class Repository

    KEY = "messages_to_track"

    def initialize
      @redis_client = Redis.new(url: ENV['REDIS_URL'])      
    end

    def save messages
      if messages.is_a? Array
        messages_to_save = read
        messages.each do |m|
          messages_to_save[m.identifier] = m.to_h
        end
        @redis_client.set(KEY, messages_to_save.to_json)
      else
        @redis_client.set(KEY, messages.to_json)
      end
    end

    def delete message_id=nil
      if message_id.nil?
        @redis_client.del(KEY)
      else
        messages = read
        messages.delete message_id
        save messages
      end
    end

    def read
      JSON.parse((@redis_client.get(KEY) || "{}"), symbolize_names: true)
    end

  end

end