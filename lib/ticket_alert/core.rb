require "ticket_alert/listener"
require "ticket_alert/tracker"
require "ticket_alert/notifier"
require "json"
require "redis"

module TicketAlert

  class Core

    def start redis_client=nil, listener=nil, tracker=nil, notifier=nil
      notifier = notifier || Notifier.new
      notifier.configure
      listener = listener || Listener.new
      listener.configure
      redis_client = redis_client || Redis.new(url: ENV['REDIS_URL'])
      tracker = tracker || Tracker.new
      
      messages_to_track = fetch_messages listener, notifier, redis_client
    
      puts "Start tracking..."
      tracker.open
      track_tickets tracker, notifier, messages_to_track
      tracker.quit
      puts "Finish tracking..."
    
      redis_client.set('messages_to_track', messages_to_track.to_json)
    end
  
    def fetch_messages listener, notifier, redis_client
      messages_to_track = JSON.parse((redis_client.get('messages_to_track') || "{}"), symbolize_names: true)
      messages_received = listener.last_messages_received
      messages_received.each do |message|
        if message.error.nil?
          messages_to_track[message.identifier.to_sym] = message.to_h
        else
          notifier.notify "No entiendo tu idioma :)", "Vaaya lo siento :P no entiendo el origen, destino o fecha que me indicas. Recuerda no responder a este mensaje. Te paso un ejemplo: valencia madrid 10/10/2017"
        end
      end
      messages_to_track
    end
  
    def track_tickets tracker, notifier, messages_to_track
      messages_to_track.each do |identifier, message|
        if tracker.avaiable_tickets_in? message[:date], message[:origin], message[:destination]
          notifier.notify "¡Biennn ya están aquí!", "¡Ya están disponibles los billetes #{message[:origin]}-#{message[:destination]} para el #{message[:date]}!"
          messages_to_track.delete identifier
          puts "Avaiable tickes for #{message[:origin]}-#{message[:destination]} on #{message[:date]}"
        else
          puts "Not avaiable tickes for #{message[:origin]}-#{message[:destination]} on #{message[:date]}"
        end
      end
    end

  end

end