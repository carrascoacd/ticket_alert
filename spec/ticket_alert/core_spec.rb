require 'ticket_alert'

describe TicketAlert::Core, acceptance: true do
  
  let(:redis) { instance_double("Redis") }
  let(:notifier) { instance_double("TicketAlert::Notifier") }
  let(:listener) { instance_double("TicketAlert::Listener") }
  let(:tracker) { instance_double("TicketAlert::Tracker") }
  let(:core) { TicketAlert::Core.new }

  before :each do
    allow(notifier).to receive(:configure)
    allow(listener).to receive(:configure)
    allow(tracker).to receive(:start)
    allow(tracker).to receive(:quit)
  end

  it "find avaiable tickes for stored messages in redis and delete them" do
    allow(redis).to receive(:get).with("messages_to_track").and_return("{\"58280e57be2b728d88195b3eef5ff33d\":{\"date\":\"29/03/2018\",\"origin\":\"VALENCIA\",\"destination\":\"MADRID\",\"error\":null,\"date\":\"29/03/2018\",\"origin\":\"VALENCIA\",\"destination\":\"MADRID\"}}")
    allow(listener).to receive(:last_messages_received).and_return([])
    allow(tracker).to receive(:avaiable_tickets_in?).with("29/03/2018", "VALENCIA", "MADRID").and_return(true)
    allow(notifier).to receive(:notify)
    allow(redis).to receive(:set)
    
    core.start redis, listener, tracker, notifier

    expect(redis).to have_received(:set).with("messages_to_track", "{}")
    expect(notifier).to have_received(:notify).with("¡Biennn ya están aquí!", "¡Ya están disponibles los billetes VALENCIA-MADRID para el 29/03/2018!")
  end

  it "save the message in redis if not avaiable tickets yet" do
    allow(redis).to receive(:get).with("messages_to_track").and_return(nil)
    allow(listener).to receive(:last_messages_received).and_return([TicketAlert::Message.new("03/03/2019", "MADRID", "VALENCIA")])
    allow(tracker).to receive(:avaiable_tickets_in?).with("03/03/2019", "MADRID", "VALENCIA").and_return(false)
    allow(notifier).to receive(:notify)
    allow(redis).to receive(:set)
    
    core.start redis, listener, tracker, notifier

    expect(redis).to have_received(:set).with("messages_to_track", "{\"a3c6ca342555ea17d8d29a96e799f5f9\":{\"date\":\"03/03/2019\",\"origin\":\"MADRID\",\"destination\":\"VALENCIA\",\"error\":null}}")
  end

end