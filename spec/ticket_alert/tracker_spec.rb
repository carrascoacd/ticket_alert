require 'ticket_alert'

describe TicketAlert::Tracker do

  before :each do
    @tracker = TicketAlert::Tracker.new
  end

  after :each do
    @tracker.quit
  end

  it "check if avaiable tickets in specific date" do
    @tracker.start
    expect(@tracker.avaiable_tickets_in? date: (Date.today + 1).strftime("%d/%m/%Y")).to eql(true)
  end
end