require 'ticket_alert'

describe TicketAlert::Tracker do

  before :each do
    @tracker = TicketAlert::Tracker.new
  end

  after :each do
    @tracker.quit
  end

  it "check if avaiable tickets in specific date" do
    date = (Date.today + 2).strftime("%d/%m/%Y")
    origin = "VALENCIA"
    destination = "MADRID"
    @tracker.open
    expect(@tracker.avaiable_tickets_in? date, origin, destination).to eql(true)
  end
end