class String
  def is_i?
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
      self.to_i == self
  end
  
end