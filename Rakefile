require "bundler/gem_tasks"
require "ticket_alert"
require "redis"
require "json"

task :default => :spec

desc "Find tickets in dates"
task :find_tickets do
  
  redis = Redis.new(url: ENV['REDIS_URL'])

  listener = TicketAlert::Listener.new
  listener.configure

  dates_to_track = JSON.load(redis.get('dates_to_track')) || []

  dates_received = listener.last_dates_received
  dates_received.each do |date|
    str_date = date.strftime("%d/%m/%Y")
    dates_to_track << str_date unless dates_to_track.include? str_date
  end

  tracker = TicketAlert::Tracker.new
  notifier = TicketAlert::Notifier.new
  notifier.configure

  tracker.start
  dates_to_track.each do |date|
    if tracker.avaiable_tickets_in? date
      notifier.notify "¡Ya están disponibles los billetes para #{date}!"
      dates_to_track.delete date
    end
  end
  tracker.quit

  redis.set('dates_to_track', dates_to_track.to_json)
end
