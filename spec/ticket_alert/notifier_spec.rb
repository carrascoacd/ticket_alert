require 'ticket_alert'

Mail.defaults do
  delivery_method :test 
end
    
describe TicketAlert::Notifier do
  include Mail::Matchers

  before :each do
    Mail::TestMailer.deliveries.clear
    @notifier = TicketAlert::Notifier.new(:test)
  end

  it "send emails to recipients" do
    @notifier.notify "Title", "Message"
    is_expected.to have_sent_email
  end

end