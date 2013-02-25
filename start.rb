load 'main.rb'
load 'datacontainer.rb'
require 'logger'

log = Logger.new(STDOUT)
log.level = Logger::DEBUG
wipedb = false
ARGV.each do |x| 
  case x.upcase
    when "-WDB"
      wipedb = true
    when "-HELP"
      puts "Command Line Arguments:"
      puts "  -help  Displays this message"
      puts "  -wdb   Force a wipe and rebuild of the database"
      exit 0
    else
      puts "Unrecognized Command:'#{x}' -help for a listing of valid commands"
  end 
   
end

if not File.exists?("pcu.db") or wipedb then
  log.info "No database found, creating."
  dc = DataContainer.new(log)
  dc.create  
end

Main.new(log)

