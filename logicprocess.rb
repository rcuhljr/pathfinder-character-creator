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
  
  # Return an array of alignments
  
  def get_alignments
    alignments = []
    @dc.get_alignments.each {|alignment| alignments.push(alignment[0]) }    
    return alignments
  end
end