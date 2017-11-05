require 'date'

module TicketAlert

  Message = Struct.new(:date, :origin, :destination, :error) do

    def identifier
      Digest::MD5.hexdigest "#{date}#{origin}#{destination}"
    end

  end

  class MessageReader

    def read text
      m = text.match(/(?<origin>(?:madrid|valencia)) (?<destination>(?:madrid|valencia)) (?<date>\d{2}\/\d{2}\/\d{4})/)
      begin
        message = Message.new(Date.parse(m[:date]).strftime("%d/%m/%Y"), m[:origin].upcase, m[:destination].upcase)
      rescue ArgumentError, NoMethodError => e
        message = Message.new
        message.error = e
      end
      message
    end

  end

end