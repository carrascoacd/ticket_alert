require "ticket_alert/mail_reader"
require "ticket_alert/tracker"
require "ticket_alert/notifier_listener"
require "ticket_alert/repository_listener"
require "ticket_alert/dependency_injector"

module TicketAlert

  class TrackerHandler

    def initialize(listeners=nil, repository=nil)
      @repository = repository || Repository.new
      @repository.read
      @listeners = listeners || [ NotifierListener.new, 
                                  RepositoryListener.new(@repository)]
    end

    def start reader=nil, tracker=nil
      reader = reader || MailReader.new(:default)
      tracker = tracker || Tracker.new
      
      #fetch_new_messages reader

      # TODO add a view and view listener component
      puts "Start tracking..."
      tracker.open
      track_tickets tracker
      tracker.quit
      puts "Finish tracking..."

    end
  
    def fetch_new_messages reader
      messages =  reader.last_messages_received
      @listeners.each { |l| l.on_new_messages messages }
      messages.select{ |m| m.error.nil? }
    end
  
    def track_tickets tracker
      @repository.get(:all).each do |m|
        if tracker.available_tickets_in? m
          @listeners.each { |l| l.on_ticket_found m }
          puts "Available tickes for #{m.origin}-#{m.destination} on #{m.date}"
        else
          puts "Not available tickes for #{m.origin}-#{m.destination} on #{m.date}"
        end
      end
    end

  end

end