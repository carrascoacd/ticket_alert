require 'ticket_alert'

describe TicketAlert::Repository do

  let(:repository){ TicketAlert::Repository.new }
  let(:redis_client){ Redis.new }

  after :each do
    repository.delete :all
  end

  it "save messages" do
    expected_message = TicketAlert::Message.new("valencia madrid 29/03/2018")
    repository.add expected_message
    repository.save 
    expect(redis_client.get(TicketAlert::Repository::KEY)).to eql({expected_message.identifier => expected_message.to_h}.to_json)
  end

  it "read messages"do
    expected_message = TicketAlert::Message.new("valencia madrid 29/03/2018")
    redis_client.set(TicketAlert::Repository::KEY, {expected_message.identifier => expected_message.to_h}.to_json)
    repository.read
    message = repository.get(expected_message.identifier)
    expect(message.to_h).to eql(expected_message.to_h)
  end

  it "delete a message" do
    expected_message = TicketAlert::Message.new("valencia madrid 29/03/2018")
    repository.add [expected_message]
    repository.delete expected_message.identifier
    expect(repository.get(:all)).to eql([])
  end

  it "add a message" do
    expected_message = TicketAlert::Message.new("valencia madrid 29/03/2018")
    repository.add expected_message
    expect(repository.get(:all)).to eq([expected_message])
  end

end