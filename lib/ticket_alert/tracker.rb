require 'watir'

module TicketAlert

  class Tracker
 
    def start
      browser_name = ENV.fetch('BROWSER', 'phantomjs')
      @browser = Watir::Browser.new browser_name.to_sym
    end

    def avaiable_tickets_in? date, origin, destination
      @browser.goto 'http://www.renfe.com'
      @browser.input(id: 'IdOrigen').wait_until_present
      search_tickets_in date, origin, destination

      retries = 0
      max_retries = 10
      until retries > max_retries
        begin
          retries += 1
          Watir::Wait.until { @browser.p(id: 'tab-mensaje_contenido').exists? }
          return avaiable_tickets?
        rescue Selenium::WebDriver::Error::ServerError
          sleep(1)
        end
      end

    end

    def search_tickets_in date, origin, destination
      from_tag = @browser.input id: 'IdOrigen'
      to_tag = @browser.input id: 'IdDestino'
      date_tag = @browser.input id: '__fechaIdaVisual'
      buy_button = @browser.button class: %w(btn btn_home)

      from_tag.send_keys origin[0]
      sleep(1)
      from_tag.send_keys :enter
      to_tag.send_keys destination[0]
      sleep(1)
      to_tag.send_keys :enter
      date_tag.to_subtype.clear
      date_tag.send_keys date

      buy_button.click
      sleep(1)
    end
    
    def avaiable_tickets?
      avaiable_tickets = false
      begin
        Watir::Wait.until(timeout: 20) { @browser.span(:xpath, "//span[text()='AVE']").exists? }
      rescue Watir::Wait::TimeoutError => e
      end
      avaiable_tickets
    end

    def quit
      @browser.quit
    end

  end

end
