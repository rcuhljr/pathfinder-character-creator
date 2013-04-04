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

load 'utilities.rb'

class DataManager
  def initialize(logger)
    @log = logger
    @char_file_ext = "pcf"
    @camp_file_ext = "pcs"
  end

  def load(name)    
    @log.debug {"loaded #{name}"}
    dataFile = File.new(name,"r")      
    return Marshal.load(dataFile)
  end
  
  def save_character(name, data)
    name += name + ".#{@char_file_ext}" unless name =~ /.*\.#{@char_file_ext}$/i
    save(name, data)  
  end
  
  def save_campaign(name, data)
    name += name + ".#{@camp_file_ext}" unless name =~ /.*\.#{@camp_file_ext}$/i
    save(name, data)
  end
  
  def save(name, data)    
    @log.debug {"saved #{name}"}
    dataFile = File.new(name,"w")        
    Marshal.dump(data,dataFile)
    dataFile.close
  end
end