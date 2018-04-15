require 'watir'

module TicketAlert

  class Tracker
 
    def open
      browser_name = ENV.fetch('BROWSER', 'phantomjs')
      @browser = Watir::Browser.new browser_name.to_sym
    end

    def avaiable_tickets_in? message
      @browser.goto 'http://www.renfe.com'
      @browser.input(id: 'IdOrigen').wait_until_present
      search_tickets_in message

      retries = 0
      max_retries = 10
      until retries > max_retries
        begin
          retries += 1
          Watir::Wait.until { @browser.p(id: 'tab-mensaje_contenido').exists? }
          return avaiable_tickets? message
        rescue Selenium::WebDriver::Error::ServerError
          sleep(1)
        end
      end
    end

    def search_tickets_in message
      from_tag = @browser.input id: 'IdOrigen'
      to_tag = @browser.input id: 'IdDestino'
      date_tag = @browser.input id: '__fechaIdaVisual'
      buy_button = @browser.button class: %w(btn btn_home)

      message.origin.each_char do |c|
        from_tag.send_keys c
      end
      sleep(1)
      from_tag.send_keys :enter
      message.destination.each_char do |c|
        to_tag.send_keys c
      end
      sleep(1)
      
      to_tag.send_keys :enter
      date_tag.to_subtype.clear
      date_tag.send_keys message.date

      buy_button.click
      sleep(1)
    end
    
    def avaiable_tickets? message
      avaiable_tickets = false
      begin
        Watir::Wait.until(timeout: 20) do
          avaiable_tickets = @browser.span(:xpath, "//span[text()='AVE']").exists?
          if avaiable_tickets and message.hour
            avaiable_tickets = @browser.span(:xpath, 
              "//span[contains(@class, 'hour salida') and text()='#{message.hour.gsub(":", ".")}']").exists?
          end
        end
      rescue Watir::Wait::TimeoutError => e
      end
      avaiable_tickets
    end

    def quit
      @browser.quit
    end

  end

end
