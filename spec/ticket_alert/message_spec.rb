require 'ticket_alert'

describe TicketAlert::Message do

  it "reads the date, origin and destination and returns a message" do
    message = TicketAlert::Message.new " madrid valencia 10/12/2017"
    expect(message.date).to eql("10/12/2017")
    expect(message.origin).to eql("MADRID")
    expect(message.destination).to eql("VALENCIA")
  end

end