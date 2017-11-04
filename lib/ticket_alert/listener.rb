require 'mail'
require 'dotenv/load'
require 'date'

module TicketAlert

  class Listener

    def configure
      Mail.defaults do
        retriever_method :pop3, :address    => ENV['RETRIEVER_METHOD_ADDRESS'],
                                :port       => 995,
                                :user_name  => ENV['RETRIEVER_METHOD_USERNAME'],
                                :password   => ENV['RETRIEVER_METHOD_PASSWORD'],
                                :enable_ssl => true
      end
    end

    def last_dates_received
      last_mails = Mail.find(:what => :last)
      last_dates = []
      last_mails.each do |mail|
        begin
          last_dates << Date.parse(mail.body.to_s)
        rescue ArgumentError
        end
      end
      last_dates
    end

  end

end