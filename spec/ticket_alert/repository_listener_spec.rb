require 'ticket_alert/repository_listener'

describe TicketAlert::RepositoryListener, here: true do

  let(:repository) { instance_double("TicketAlert::Repository") }

  before :each do
    @listener = TicketAlert::RepositoryListener.new(repository)
  end

  it "save the messages without error" do
    ok_message = TicketAlert::Message.new " madrid valencia 10/12/2017"
    error_message = TicketAlert::Message.new "error!"
    allow(repository).to receive(:read)
    allow(repository).to receive(:add)
    allow(repository).to receive(:save)
    @listener.on_new_messages [ok_message, error_message]
    expect(repository).to have_received(:read)
    expect(repository).to have_received(:add).with([ok_message])
    expect(repository).to have_received(:save)
  end


  it "delete the message" do
    message = TicketAlert::Message.new " madrid valencia 10/12/2017"
    allow(repository).to receive(:delete)
    @listener.on_ticket_found message
    expect(repository).to have_received(:delete).with(message.identifier)
  end

end