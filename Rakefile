require "bundler/gem_tasks"
require "ticket_alert"

task :default => :spec

desc "Find tickets in dates"
task :find_tickets do
  TicketAlert::TrackerHandler.new.start
end
