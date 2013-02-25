load 'character.rb'

# Contains the main set of business logic

class LogicProcess
  def initialize(logger)
    @log = logger
    @dc = DataContainer.new(@log)
    @dm = DataManager.new(@log)
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
  
  def save_character(filename)
    @log.debug { "dumped #{@char.name} of alignment #{@char.alignment}" }
    @dm.save(filename, @char)
  end
  
  def open_character(filename)
    @char = @dm.load(filename)
  end
  
  # Set the name field on the character object
  
  def set_name(name)
    @char.name = name
  end
  
  def set_player(player)
    @char.player = player
  end
  
  def set_alignment(alignment)
    @char.alignment = alignment
  end
  
  def set_base_stat(index, value)
    @char.base_attribute_scores[index] = value
  end
  
  def set_gender(gender)
    @char.gender = gender
  end
  # Returns an array of alignments
  
  def get_alignments
    alignments = []
    @dc.get_alignments.each {|alignment| alignments.push(alignment[0]) }    
    return alignments
  end
  
  # Returns an array of point buys
  
  def get_pointbuys
    pointbuys = []
    @dc.get_pointbuys.each {|pointbuy| pointbuys.push(alignment[0]) }    
    return pointbuys
  end
  
  # Returns an array of genders
  
  def get_genders
    genders = []
    @dc.get_genders.each {|gender| genders.push(gender[0]) }    
    return genders
  end
  
end