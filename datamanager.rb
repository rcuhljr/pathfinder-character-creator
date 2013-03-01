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