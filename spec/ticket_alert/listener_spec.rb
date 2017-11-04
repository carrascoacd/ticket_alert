require 'ticket_alert'

describe TicketAlert::Listener do

  before :each do
    @listener = TicketAlert::Listener.new
  end

  it "check if has not incoming date" do
    allow(Mail).to receive(:last).and_return(Mail.new body: 'other invalid body')
    expect(@listener.last_date_received).to eql(nil)
  end

  it "check if has incoming date" do
    expected_date = '10/10/10'
    allow(Mail).to receive(:last).and_return(Mail.new body: expected_date)
    expect(@listener.last_date_received).to eql(Date.parse expected_date)
  end

end