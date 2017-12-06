require 'date'
require 'digest'

module TicketAlert

  class Message
    attr_accessor :date, :origin, :destination, :error

    def initialize text
      m = text.match(/(?<origin>(?:madrid|valencia)) (?<destination>(?:madrid|valencia)) (?<date>\d{2}\/\d{2}\/\d{4})/)
      begin
        self.date = Date.parse(m[:date]).strftime("%d/%m/%Y")
        self.origin = m[:origin].upcase
        self.destination = m[:destination].upcase
      rescue ArgumentError, NoMethodError => e
        self.error = e
      end
    end

    def identifier
      Digest::MD5.hexdigest("#{self.date}#{self.origin}#{self.destination}").to_sym
    end

    def to_h
      {date: self.date, origin: self.origin, destination: self.destination, error: self.error}
    end

  end

end