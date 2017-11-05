require 'ticket_alert'

describe TicketAlert::MessageReader do

  before :each do
    @reader = TicketAlert::MessageReader.new
  end

  it "reads the date, origin and destination and returns a message" do
    message = @reader.read " madrid valencia 10/12/2017"
    expect(message.date).to eql("10/12/2017")
    expect(message.origin).to eql("MADRID")
    expect(message.destination).to eql("VALENCIA")
  end

end