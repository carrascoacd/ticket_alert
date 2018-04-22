require 'ticket_alert'

describe TicketAlert::DependencyInjector do
  
  let(:dependency_injector) { TicketAlert::DependencyInjector.instance }

  it "should register a new object dependency" do
    expected_dependency = Hash.new
    dependency_injector.register expected_dependency
    dependency_injector.register Array.new
    expect(dependency_injector.inject(Hash)).to eql(expected_dependency)
  end

end