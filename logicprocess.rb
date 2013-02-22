load 'character.rb'

# Contains the main set of business logic

class LogicProcess
  def initialize()
    @unsaved_changes = false
    new_character
  end
  
  def unsaved_changes?
    return @unsaved_changes
  end
  
  def new_character
    @char = Character.new    
  end

  def get_character
    return @char
  end
end