require "ticket_alert/listener"
require "ticket_alert/tracker"
require "ticket_alert/notifier"
require "ticket_alert/repository"
require "ticket_alert/dependency_injector"

module TicketAlert

  class Core

    def start repository=nil, listener=nil, tracker=nil, notifier=nil
      notifier = notifier || Notifier.new(:default)
      listener = listener || Listener.new(:default)
      repository = repository || Repository.new
      tracker = tracker || Tracker.new
      
      repository.read
      new_messages = fetch_new_messages listener, notifier
      repository.add new_messages
    
      puts "Start tracking..."
      tracker.open
      track_tickets tracker, notifier, repository
      tracker.quit
      puts "Finish tracking..."
    
      repository.save
    end
  
    def fetch_new_messages listener, notifier
      messages = listener.last_messages_received
      messages.reject{ |m| m.error.nil? }.each do |m|
        notifier.notify "No entiendo tu idioma :)", "Vaaya lo siento :P no entiendo el origen, destino o fecha que me indicas esto es lo que me has enviado:\n #{m.text}\n. Recuerda no responder a este mensaje.\n Te paso un ejemplo: valencia madrid 10/12/2017"
      end
      ok_messages = messages.select{ |m| m.error.nil? }
      ok_messages.each do |m|
        notifier.notify "Mensaje recibido!", "He recibido la orden para #{m.origin}-#{m.destination} el #{m.date}"
      end
      ok_messages
    end
  
    def track_tickets tracker, notifier, repository
      repository.get(:all).each do |m|
        if tracker.avaiable_tickets_in? m.date, m.origin, m.destination
          notifier.notify "¡Biennn ya están aquí!", "¡Ya están disponibles los billetes #{m.origin}-#{m.destination} para el #{m.date}!"
          repository.delete m.identifier
          puts "Avaiable tickes for #{m.origin}-#{m.destination} on #{m.date}"
        else
          puts "Not avaiable tickes for #{m.origin}-#{m.destination} on #{m.date}"
        end
      end
    end

  end

end