require 'ticket_alert'

describe TicketAlert::Core, here: true do
  
  let(:repository) { instance_double("TicketAlert::Repository") }
  let(:listener) { double("Lisener") }
  let(:mail_reader) { instance_double("TicketAlert::mail_reader") }
  let(:tracker) { instance_double("TicketAlert::Tracker") }
  let(:core) { TicketAlert::Core.new [listener], repository }

  before :each do
    allow(tracker).to receive(:open)
    allow(tracker).to receive(:quit)
  end

  it "find avaiable tickes for stored messages in repository and delete them" do
    messages = [TicketAlert::Message.new("valencia madrid 29/03/2018")]
    allow(repository).to receive(:get).with(:all).and_return(messages)
    new_messages = []
    allow(mail_reader).to receive(:last_messages_received).and_return(new_messages)
    allow(tracker).to receive(:avaiable_tickets_in?).and_return(true)
    allow(listener).to receive(:on_ticket_found)
    allow(listener).to receive(:on_new_messages)
    
    core.start mail_reader, tracker

    expect(listener).to have_received(:on_ticket_found)
  end

  it "save the message in repository if not avaiable tickets yet" do
    messages = []
    allow(repository).to receive(:get).with(:all).and_return(messages)
    new_messages = [TicketAlert::Message.new("madrid valencia 03/03/2019")]
    allow(mail_reader).to receive(:last_messages_received).and_return(new_messages)
    allow(tracker).to receive(:avaiable_tickets_in?).and_return(false)
    allow(listener).to receive(:on_ticket_found)
    allow(listener).to receive(:on_new_messages)
    
    core.start mail_reader, tracker

    expect(listener).not_to have_received(:on_ticket_found)
  end

  it "notifies error messages and return right messages" do
    error_message = TicketAlert::Message.new("error message")
    ok_message = TicketAlert::Message.new("madrid valencia 03/03/2019")
    allow(mail_reader).to receive(:last_messages_received).and_return([ok_message, error_message])
    allow(listener).to receive(:on_new_messages)
    
    new_messages = core.fetch_new_messages mail_reader

    expect(new_messages).to eq([ok_message])
  end

end