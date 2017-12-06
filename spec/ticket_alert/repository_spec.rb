require 'ticket_alert'

describe TicketAlert::Repository do

  let(:repository){ TicketAlert::Repository.new }
  let(:redis_client){ Redis.new }

  after :each do
    repository.delete
  end

  it "save messages" do
    repository.save [TicketAlert::Message.new("valencia madrid 29/03/2018")]
    expect(redis_client.get(TicketAlert::Repository::KEY)).to eql("{\"58280e57be2b728d88195b3eef5ff33d\":{\"date\":\"29/03/2018\",\"origin\":\"VALENCIA\",\"destination\":\"MADRID\",\"error\":null}}")
  end

  it "read messages"do
    expected_message = TicketAlert::Message.new("valencia madrid 29/03/2018")
    repository.save [expected_message]
    messages = repository.read
    expect({expected_message.identifier => expected_message.to_h}).to eql(messages)
  end

  it "delete messages" do
    expected_message = TicketAlert::Message.new("valencia madrid 29/03/2018")
    repository.save [expected_message]
    repository.delete expected_message.identifier
    expect(repository.read).to eql({})
  end

end