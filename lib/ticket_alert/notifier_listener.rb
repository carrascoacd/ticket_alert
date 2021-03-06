require 'ticket_alert/notifier'

module TicketAlert

  class NotifierListener

    def initialize(notifier=nil)
      @notifier = notifier || Notifier.new
    end

    def on_new_messages(message_list)
      message_list.each do |message|
        if message.error.nil? 
          @notifier.notify "Mensaje recibido!", "He recibido la orden para #{message.origin}-#{message.destination} el #{message.date} #{message.hour}"
        else
          @notifier.notify "No entiendo tu idioma :)", "Vaaya lo siento :P no entiendo el origen, destino o fecha que me indicas esto es lo que me has enviado:\n #{message.text}\n. Recuerda no responder a este mensaje.\n Te paso un ejemplo: valencia madrid 10/12/2017"
        end
      end
    end

    def on_ticket_found(message)
      @notifier.notify "¡¡Ya están aquí!!", "Ya están aquí los billetes para #{message.origin}-#{message.destination} el #{message.date} #{message.hour}"
    end
  end

end