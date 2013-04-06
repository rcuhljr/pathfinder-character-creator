class String
  def integer?
    self.to_i.to_s == self
  end
    
  def bonus
    val = ((self.to_i-10)/2)
    return val.to_s if val < 0
    return "+" + val.to_s
  end
end

class Fixnum
  def is_i?
      return true
  end  
  
  def bonus
    self.to_i.to_s.bonus
  end
end

module Gtk  
  class ListStore
    attr_accessor :column_count
    def _dump level      
      return Marshal.dump(build_data_array)
    end

    def build_data_array
    arr_of_arr = []
      headers = []
      arr_of_arr << headers
      self.each do |model, path, iter| 
        arr = []        
        (0..(@column_count-1)).each do |count|        
          headers << iter[count].class if arr_of_arr.length == 1
          arr << iter[count]        
          count += 1
        end
        arr_of_arr << arr
      end
      return arr_of_arr
    end
    
    def self._load(data)
      data = Marshal.load(data)
      headers = data.shift      
      store = new(*headers)      
      store.column_count = headers.size
      data.each{|item_row| item_row.each_with_index{ |value, index| 
         iter = store.append(); iter[index] = value }}
      return store
    end
    
    def ==(other)
      puts "comparing"
      mydata = self.build_data_array
      puts "base data #{mydata}"
      otherdata = other.build_data_array      
      puts "other data #{otherdata}"      
      return mydata == otherdata
    end
  end
end