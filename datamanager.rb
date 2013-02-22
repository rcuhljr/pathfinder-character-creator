class DataManager
  def load(name)
    dataFile = File.new(name,"r")      
    return Marshal.load(dataFile)
  end

  def store(name, data)
    dataFile = File.new(name,"w")        
    Marshal.dump(data,dataFile)
    dataFile.close
  end
end