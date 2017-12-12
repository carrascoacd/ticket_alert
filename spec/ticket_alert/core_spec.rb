require 'ticket_alert'

describe TicketAlert::Core do
  
  let(:repository) { instance_double("TicketAlert::Repository") }
  let(:notifier) { instance_double("TicketAlert::Notifier") }
  let(:listener) { instance_double("TicketAlert::Listener") }
  let(:tracker) { instance_double("TicketAlert::Tracker") }
  let(:core) { TicketAlert::Core.new }

  before :each do
    allow(tracker).to receive(:open)
    allow(tracker).to receive(:quit)
  end

  it "find avaiable tickes for stored messages in repository and delete them" do
    messages = [TicketAlert::Message.new("valencia madrid 29/03/2018")]
    allow(repository).to receive(:get).with(:all).and_return(messages)
    new_messages = []
    allow(listener).to receive(:last_messages_received).and_return(new_messages)
    allow(tracker).to receive(:avaiable_tickets_in?).with("29/03/2018", "VALENCIA", "MADRID").and_return(true)
    allow(notifier).to receive(:notify)
    allow(repository).to receive(:add).with(new_messages)
    allow(repository).to receive(:read)
    allow(repository).to receive(:save)
    allow(repository).to receive(:delete)
    
    core.start repository, listener, tracker, notifier

    expect(repository).to have_received(:delete).with(messages[0].identifier)
    expect(repository).to have_received(:save)
    expect(notifier).to have_received(:notify).with("¡Biennn ya están aquí!", "¡Ya están disponibles los billetes VALENCIA-MADRID para el 29/03/2018!")
  end

  it "save the message in repository if not avaiable tickets yet" do
    messages = []
    allow(repository).to receive(:get).with(:all).and_return(messages)
    new_messages = [TicketAlert::Message.new("madrid valencia 03/03/2019")]
    allow(listener).to receive(:last_messages_received).and_return(new_messages)
    allow(tracker).to receive(:avaiable_tickets_in?).with("03/03/2019", "MADRID", "VALENCIA").and_return(false)
    allow(notifier).to receive(:notify)
    allow(repository).to receive(:add).with(new_messages)
    allow(repository).to receive(:read)
    allow(repository).to receive(:save)
    
    core.start repository, listener, tracker, notifier

    expect(repository).to have_received(:save)
  end

end