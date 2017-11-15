require "bundler/gem_tasks"
require "ticket_alert"
require "redis"
require "json"
require "digest"

task :default => :spec

desc "Find tickets in dates"
task :find_tickets do
  
  redis = Redis.new(url: ENV['REDIS_URL'])
  notifier = TicketAlert::Notifier.new
  notifier.configure

  listener = TicketAlert::Listener.new
  listener.configure

  messages_to_track = JSON.load(redis.get('messages_to_track')) || {}

  messages_received = listener.last_messages_received
  messages_received.each do |message|
    if message.error.nil?
      messages_to_track[message.identifier] = message.to_h
    else
      notifier.notify "No entiendo tu idioma :)", "Vaaya lo siento :P no entiendo el origen, destino o fecha que me indicas. Te paso un ejemplo: valencia madrid 10/10/2017"
    end
  end

  tracker = TicketAlert::Tracker.new

  tracker.start
  puts "Starting tracking..."
  messages_to_track.each do |identifier, message|
    if tracker.avaiable_tickets_in? message['date'], message['origin'], message['destination']
      notifier.notify "¡Biennn ya están aquí!", "¡Ya están disponibles los billetes #{message['origin']}-#{message['destination']} para el #{message['date']}!"
      messages_to_track.delete identifier
      puts "Avaiable tickes for #{message['origin']}-#{message['destination']} on #{message['date']}"
    else
      puts "Not avaiable tickes for #{message['origin']}-#{message['destination']} on #{message['date']}"
    end
  end
  puts "Finishing tracking..."
  tracker.quit

  redis.set('messages_to_track', messages_to_track.to_json)
end
