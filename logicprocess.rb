require 'ostruct'

# Contains the main set of business logic

class LogicProcess
  def initialize(logger)
    @log = logger
    @dc = DataContainer.new(@log)
    @dm = DataManager.new(@log)
    @unsaved_changes = false
    new_character
    new_campaign
    
    #TODO is there a better way to do this? should it be a database issue?
    @point_buy_costs = {7 => -4, 8 => -2, 9 => -1, 10 => 0, 11 => 1, 12 => 2, 13 => 3, 14 => 5, 15 => 7, 16 => 10, 17 => 13, 18 => 17}
  end
  
  def unsaved_campaign_changes?
    @log.debug {"unsaved_camp_changes"}
    #unchanged campaign
    return false if create_campaign == @camp
    #campaign that has never been saved
    return true if @camp.file_name.nil?
    #campaign identical to saved version
    
    return @camp != @dm.load(@camp.file_name)
  end
  
  def unsaved_changes?
    @log.debug {"unsaved_changes"}
    #unchanged character
    return false if create_character == @char
    #character that has never been saved
    return true if @char.file_name.nil?
    #character identical to saved version
    return @char != @dm.load(@char.file_name)    
  end
  
  def new_character
    @char = create_character
  end
  
  def create_character
    OpenStruct.new(
      :base_attribute_scores => Array.new(6, 10), 
      :race_attribute_scores => Array.new(6, 0),
      :misc_attribute_scores => Array.new(6, 0))
  end

  def get_character
    return @char
  end
  
  def new_campaign
    @camp = create_campaign
  end
  
  def create_campaign
    OpenStruct.new(     
      :pointbuy => 15)
  end

  def get_campaign
    return @camp
  end
  
  def save_character(filename)
    @log.debug { "dumped #{@char.name} of alignment #{@char.alignment}" }
    @char.file_name = filename
    @dm.save_character(filename, @char)
  end
  
  def open_character(filename)
    @char = @dm.load(filename)
  end
  
  #Save the current campaign to filename
  
  def save_campaign(filename)
    @log.debug { "dumped #{@char.name} of alignment #{@char.alignment}" }
    @camp.file_name = filename
    @dm.save_campaign(filename, @camp)
  end
  
  def open_campaign(filename)
    @camp = @dm.load(filename)
  end
  
  def set_camp_name(name)
    @camp.name = name
  end
  
  def set_pointbuy(pbuy)
    @camp.pointbuy = pbuy
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
  
  def set_misc_stat(index, value)
    @char.misc_attribute_scores[index] = value
  end
  
  def set_race_stat(index, value)
    @char.race_attribute_scores[index] = value
  end
  
  def get_stat_total(index)
    @char.base_attribute_scores[index].to_i + @char.misc_attribute_scores[index].to_i + @char.race_attribute_scores[index].to_i
  end
  
  def get_stat_pointbuy()
    scores = @char.base_attribute_scores;
    pointbuy = 0;
    scores.each do |x|
      val = @point_buy_costs[x.to_i]
      return "**" if val.nil?
      pointbuy += val
    end
    return pointbuy
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
    @dc.get_pointbuys.each {|pointbuy| pointbuys.push(pointbuy[0]) }    
    return pointbuys
  end
  
  # Returns an array of genders
  
  def get_genders
    genders = []
    @dc.get_genders.each {|gender| genders.push(gender[0]) }    
    return genders
  end
  
end