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
    def marshal_dump
      arr_of_arr = []
      self.each do |item| 
        arr = []
        count = 0
        while not item[count].nil? 
          arr << item[count]        
          count += 1
        end
        arr_of_arr << arr
      end
      return arr_of_arr.marshal_dump
    end
  
  end
end