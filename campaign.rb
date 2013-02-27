# Data wrapper for a character

class Campaign
  attr_accessor :name, :pointbuy
  def initialize()
    @name = "default campaign"
    @pointbuy = 15
    #TODO set defaults off database values.
  end
    
end