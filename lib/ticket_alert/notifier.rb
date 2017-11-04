require 'mail'

module TicketAlert

  class Notifier

    def configure
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

    def notify message
      Mail.deliver   do
        from    'simonticketalert@gmail.com'
        to      ['carrasco.acd@gmail.com']
        subject message
      end
    end

  end

end