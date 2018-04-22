require 'ticket_alert'

describe TicketAlert::Tracker do

  before :all do
    @tracker = TicketAlert::Tracker.new 
    @tracker.open
  end

  after :all do
    @tracker.quit
  end

  it "check if available tickets in specific date" do
    message = TicketAlert::Message.new "valencia madrid #{(Date.today + 2).strftime("%d/%m/%Y")}"
    expect(@tracker.available_tickets_in? message).to eql(true)
  end

  it "check if available tickets in specific date and hour" do
    message = TicketAlert::Message.new "valencia madrid #{(Date.today + 2).strftime("%d/%m/%Y")} 06:30"
    expect(@tracker.available_tickets_in? message).to eql(true)
  end

  it "check if not available tickets in specific date and hour" do
    message = TicketAlert::Message.new "valencia madrid #{(Date.today + 2).strftime("%d/%m/%Y")} 06:32"
    expect(@tracker.available_tickets_in? message).to eql(false)
  end

end