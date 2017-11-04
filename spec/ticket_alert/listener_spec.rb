require 'ticket_alert'

describe TicketAlert::Listener do

  before :each do
    @listener = TicketAlert::Listener.new
  end

  it "check if has not incoming date" do
    allow(Mail).to receive(:find).and_return([Mail.new(body: "body without date")])
    expect(@listener.last_dates_received).to eql([])
  end

  it "check if has incoming date" do
    expected_date = '10/10/10'
    allow(Mail).to receive(:find).and_return([Mail.new(body: expected_date)])
    expect(@listener.last_dates_received).to eql([Date.parse(expected_date)])
  end

end