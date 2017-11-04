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

      Mail.defaults do
        delivery_method :smtp, :address    => ENV['DELIVERY_METHOD_ADDRESS'],
                                :port       => 587,
                                :user_name  => ENV['DELIVERY_METHOD_USERNAME'],
                                :domain => 'smart-ticketalert',
                                :password   => ENV['DELIVERY_METHOD_USERNAME'],
                                :authentication  => 'plain',
                                :enable_starttls_auto => true
      end
    end

    def last_date_received
      last_mail = Mail.last
      begin
        last_date = Date.parse last_mail.body.to_s
      rescue ArgumentError
        last_date = nil
      end
      last_date
    end

  end

end