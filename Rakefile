require 'bundler/gem_tasks'
require 'ticket_alert'
require 'sentry-raven'
require 'optparse'

task default: :spec

desc 'Find tickets in dates'
task :find_tickets do
  Raven.capture do
    TicketAlert::TrackerHandler.new.start
  end
end
