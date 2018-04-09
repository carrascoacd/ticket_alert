require 'ticket_alert'

describe TicketAlert::Tracker do

  before :each do
    @tracker = TicketAlert::Tracker.new
  end

  after :each do
    @tracker.quit
  end

  it "check if avaiable tickets in specific date" do
    message = TicketAlert::Message.new "valencia madrid #{(Date.today + 2).strftime("%d/%m/%Y")}"
    @tracker.open
    expect(@tracker.avaiable_tickets_in? message).to eql(true)
  end
end