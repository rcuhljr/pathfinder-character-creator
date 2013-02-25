# Data wrapper for a character

class Character
  attr_accessor :name, :player, :alignment, :gender, :base_attribute_scores, :race_attribute_scores, :misc_attribute_scores
  def initialize()
    @base_attribute_scores = Array.new(6, 10)
    @race_attribute_scores = Array.new(6, 0)
    @misc_attribute_scores = Array.new(6, 0)
  end
    
end