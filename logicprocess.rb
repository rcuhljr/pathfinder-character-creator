# Author:: Robert Uhl (mailto:uhlrc@yahoo.com)
# License:: GPL V2
# Copyright:: (C) 2013  Robert Uhl

#--
#This program is free software; you can redistribute it and/or
#modify it under the terms of the GNU General Public License
#as published by the Free Software Foundation; either version 2
#of the License, or (at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#++

require 'ostruct'
require_relative 'datacontainer.rb'
require_relative 'datamanager.rb'
# Contains the main set of business logic

class LogicProcess  
  def initialize(logger, data_sources = {})
    @log = logger    
    @dc = data_sources[:dc] ||= DataContainer.new(@log)
    @dm = data_sources[:dm] ||= DataManager.new(@log)
    @unsaved_changes = false
    new_character
    new_campaign
    
    #TODO is there a better way to do this? should it be a database issue?
    @@point_buy_costs = {7 => -4, 8 => -2, 9 => -1, 10 => 0, 11 => 1, 12 => 2, 13 => 3, 14 => 5, 15 => 7, 16 => 10, 17 => 13, 18 => 17}
  end
  
  def has_unsaved_campaign_changes?
    @log.debug {"unsaved_camp_changes"}
    #unchanged campaign
    return false if create_campaign == @camp
    #campaign that has never been saved
    return true if @camp.file_name.nil?
    #campaign identical to saved version    
    return @camp != @dm.load(@camp.file_name)
  end
  
  def has_unsaved_changes?
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
      :misc_attribute_scores => Array.new(6, 0),
      :levels => [],
      :level_hp => [],
      :optionals => [])
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
    @log.debug { "dumped #{@camp.name} " }
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
  
  def set_race_stat_by_name(stat, value)
    target = @dc.get_attributes.select { |x| x["name"] == stat } [0]
    set_race_stat(target["id"]-1, value)
  end
  
  def get_race_stat(index)
    @char.race_attribute_scores[index]
  end
  
  # update the race stats to selected race
  
  def set_race_stats(race)
    @char.race_attribute_scores = Array.new(@dc.get_race_stats[race][:stats_array])
    @char.race = race
    @char.optionals = []
  end
  
  def get_race_optionals(race) 
    @dc.get_race_stats[race][:optional]
  end
  
  def set_optionals(stat, index)
    @log.debug {"setting optional stat:#{stat} at index: #{index}"}    
    @char.race_attribute_scores = Array.new(@dc.get_race_stats[@char.race][:stats_array])
    
    @char.optionals[index] = stat    
    @char.optionals.each {|option| set_race_stat_by_name(stat, 2) }
    @log.debug {"updated to optionals: #{@char.optionals}"}
  end
    
  def get_attribute_names
    @dc.get_attributes.map { |x| x["name"] }
  end
  
  def get_stat_total(index)
    @char.base_attribute_scores[index].to_i + @char.misc_attribute_scores[index].to_i + @char.race_attribute_scores[index].to_i
  end
  
  def get_stat_pointbuy()
    scores = @char.base_attribute_scores;
    pointbuy = 0;
    scores.each do |x|
      val = @@point_buy_costs[x.to_i]
      return nil if val.nil?
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
  
  # Returns an array of races
  
  def get_races
    races = []
    @dc.get_races.each {|race| races.push(race[0]) }    
    return races
  end
  
  def get_class_names
    @dc.get_classes.keys
  end
  
end