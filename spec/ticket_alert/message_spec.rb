require 'ticket_alert'

describe TicketAlert::Message, here: true do

  it "reads the date, origin and destination and returns a message" do
    message = TicketAlert::Message.new " madrid valencia 10/12/2017"
    expect(message.date).to eql("10/12/2017")
    expect(message.origin).to eql("MADRID")
    expect(message.destination).to eql("VALENCIA")
    expect(message.hour).to eql(nil)
  end

  it "reads the date, origin and destination and returns a message" do
    message = TicketAlert::Message.new " madrid - valencia - 10/12/2017"
    expect(message.date).to eql("10/12/2017")
    expect(message.origin).to eql("MADRID")
    expect(message.destination).to eql("VALENCIA")
    expect(message.hour).to eql(nil)
  end
  
  it "reads the date, origin and destination and returns a message" do
    message = TicketAlert::Message.new " madrid - valencia - 10/12/2017 10:10"
    expect(message.date).to eql("10/12/2017")
    expect(message.origin).to eql("MADRID")
    expect(message.destination).to eql("VALENCIA")
    expect(message.hour).to eql("10:10")
  end

end