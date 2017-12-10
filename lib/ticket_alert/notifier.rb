require 'mail'

module TicketAlert

  class Notifier

    def initialize options=:default
      if options == :default
        Mail.defaults do
          delivery_method :smtp, :address    => ENV['DELIVERY_METHOD_ADDRESS'],
                                  :port       => 587,
                                  :user_name  => ENV['DELIVERY_METHOD_USERNAME'],
                                  :domain => 'smart-ticketalert',
                                  :password   => ENV['DELIVERY_METHOD_PASSWORD'],
                                  :authentication  => 'plain',
                                  :enable_starttls_auto => true
        end
      end
    end

    def notify title, message
      Mail.deliver   do
        from    ENV['SENDER']
        to      ENV['RECIPIENTS'].split(',')
        subject title
        body message
      end
    end

  end

end