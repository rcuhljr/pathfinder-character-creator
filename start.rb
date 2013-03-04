# A Pathfinder character creation utility
# Author:: Robert Uhl (mailto:uhlrc@yahoo.com)
# License:: GPL V2
# Copyright:: (C) 2013  Robert Uhl

#--
#This program is free software; you can redistribute it and/or
#modify it under the terms of the GNU General Public License
#as published by the Free Software Foundation; either version 2
#of the License, or (at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#++

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

