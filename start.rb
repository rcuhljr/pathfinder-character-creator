load 'main.rb'
load 'datacontainer.rb'
require 'logger'

log = Logger.new(STDOUT)
log.level = Logger::DEBUG
wipedb = true

if not File.exists?("pcu.db") or wipedb then
  log.info "No database found, creating."
  dc = DataContainer.new(log)
  dc.create  
end

Main.new(log)

