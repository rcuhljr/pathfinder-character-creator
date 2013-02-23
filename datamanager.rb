class DataManager
  def initialize(logger)
    @log = logger
    @file_ext = ".pcf"
  end

  def load(name)    
    @log.debug {"loaded #{name}"}
    dataFile = File.new(name,"r")      
    return Marshal.load(dataFile)
  end

  def save(name, data)
    name += name + @file_ext unless name =~ /.*\.pcf$/i
    @log.debug {"saved #{name}"}
    dataFile = File.new(name,"w")        
    Marshal.dump(data,dataFile)
    dataFile.close
  end
end