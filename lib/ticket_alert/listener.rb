require 'mail'
require 'dotenv/load'
require 'date'
require 'ticket_alert/message'

module TicketAlert

  class Listener

    def initialize options=:default
      if options == :default
        Mail.defaults do
          retriever_method :pop3, :address    => ENV['RETRIEVER_METHOD_ADDRESS'],
                                  :port       => 995,
                                  :user_name  => ENV['RETRIEVER_METHOD_USERNAME'],
                                  :password   => ENV['RETRIEVER_METHOD_PASSWORD'],
                                  :enable_ssl => true
        end
      end
    end

    def last_messages_received
      last_mails = Mail.find(:what => :last)
      last_messages = []
      last_mails.each do |mail|
        begin
          message = TicketAlert::Message.new mail.body.to_s
          last_messages << message unless message.nil?
        rescue ArgumentError
        end
      end
      last_messages
    end

  end

end