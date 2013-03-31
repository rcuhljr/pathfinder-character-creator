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

load 'utilities.rb'

class RaceStatsTab
  def initialize(logger, process)
    @log = logger
    @process = process;
  end

# build the race and stats tab
  
  def build_race_stats(tab_holder)
    @char = @process.get_character
    tab_label = Gtk::Label.new("Race & Stats")    
    
    race_stats_box = Gtk::VBox.new(homogeneous = false, spacing = 5)
    header_row = Gtk::HBox.new(homogeneous = false, spacing = 5)
    stats_box = Gtk::Table.new(rows = 7, columns = 6, homogeneous = false)
    race_box = Gtk::VBox.new(homogenous =false, spacing = 5)
    race_stats_row = Gtk::HBox.new(homogenous =false, spacing = nil)
    alt_race_traits_row = Gtk::HBox.new(homogenous =false, spacing = nil)
    
    build_header_row(header_row)
    
    race_stats_box.pack_start(header_row, false, false, 0)
    
    build_stats_box(stats_box)
    
    race_stats_row.pack_start(stats_box, false, false, 10)
    
    build_race_box(race_box)
    
    build_alt_traits_row(alt_race_traits_row)
    
    race_stats_row.pack_start(race_box, false, false, 10)
    
    race_stats_box.pack_start(race_stats_row, false, false, 0)
    
    race_stats_box.pack_start(alt_race_traits_row, false, false, 0)
    
    tab_holder.append_page(race_stats_box, tab_label)    
  end
  
  def build_header_row(header_row)
    name_label = Gtk::Label.new("Character Name:")
    name_entry = Gtk::Entry.new()
    name_entry.text = @char.name unless @char.name.nil?
    
    player_label = Gtk::Label.new("Player Name:")
    player_entry = Gtk::Entry.new()
    player_entry.text = @char.player unless @char.player.nil?
    
    alignment_label = Gtk::Label.new("Alignment:")
    alignment_entry = Gtk::ComboBox.new(is_text_only = true)   
    @process.get_alignments.each_with_index do |align_text, index|      
      alignment_entry.append_text(align_text)
      alignment_entry.set_active(index) if align_text == @char.alignment
    end
    
    gender_label= Gtk::Label.new("Gender:")
    gender_entry = Gtk::ComboBox.new(is_text_only = true)   
    @process.get_genders.each_with_index do |gender_text, index|
      gender_entry.append_text(gender_text)
      gender_entry.set_active(index) if gender_text == @char.gender
    end
    
    header_row.pack_start(name_label, false, false, 2)  
    header_row.pack_start(name_entry, false, false, 2)
    header_row.pack_start(player_label, false, false, 2)
    header_row.pack_start(player_entry, false, false, 2)
    header_row.pack_start(alignment_label, false, false, 2)
    header_row.pack_start(alignment_entry, false, false, 2)
    header_row.pack_start(gender_label, false, false, 2)
    header_row.pack_start(gender_entry, false, false, 2)
    
    name_entry.signal_connect("changed") { |e| @process.set_name(e.text) }
    player_entry.signal_connect("changed") { |e| @process.set_player(e.text) }
    alignment_entry.signal_connect("changed") { |e| @process.set_alignment(e.active_text) }
    gender_entry.signal_connect("changed") { |e| @process.set_gender(e.active_text) }
  end
  
  def build_stats_box(stats_box)
    
    base_stats = @char.base_attribute_scores
    race_stats = @char.race_attribute_scores
    misc_stats = @char.misc_attribute_scores
    
    spin_entries = []
    spin_entries.push(Gtk::Label.new("Score"))
    6.times {spin_entries.push(Gtk::SpinButton.new(3.0, 90.0, 1.0))}        
    
    spin_entries.each_with_index { |entry, index| 
      next unless entry.is_a? Gtk::SpinButton
      entry.value = base_stats[index-1]
    }
    
    labels = []
    labels.push(Gtk::Label.new(""))
    abbrevs = @process.get_attribute_abbrevs
    6.times {|x| labels.push(Gtk::Label.new(abbrevs[x]))}            
    
    race_entries = []
    race_entries.push(Gtk::Label.new("Race"))
    6.times {race_entries.push(Gtk::Entry.new())}    
    
    @races = []
    
    race_entries.each_with_index { |entry, index| 
      next unless entry.is_a? Gtk::Entry
      @races << entry
      entry.editable = false
      entry.width_chars = 3
      entry.text = race_stats[index-1].to_s
    }
    
    @misc = []

    misc_entries = []
    misc_entries.push(Gtk::Label.new("Misc"))
    6.times {misc_entries.push(Gtk::Entry.new())}
    
    
    misc_entries.each_with_index { |entry, index| 
      next unless entry.is_a? Gtk::Entry
      @misc << entry
      entry.editable = false 
      entry.width_chars = 3
      entry.text = misc_stats[index-1].to_s
    }
    
    total_entries = []
    total_entries.push(Gtk::Label.new("Total"))
    6.times {total_entries.push(Gtk::Entry.new())}
    
    @totals = []
    
    total_entries.each_with_index { |entry, index| 
      next unless entry.is_a? Gtk::Entry
      @totals << entry
      entry.editable = false 
      entry.width_chars = 3
      entry.text = (base_stats[index-1].to_i + race_stats[index-1].to_i + misc_stats[index].to_i).to_s
    }
    
    
    bonus_entries = []
    bonus_entries.push(Gtk::Label.new("Bonus"))
    6.times {bonus_entries.push(Gtk::Entry.new())}
    
    bonus_entries.each_with_index { |entry, index| 
      next unless entry.is_a? Gtk::Entry
      entry.editable = false 
      entry.width_chars = 3
      entry.text = total_entries[index].text.bonus
    }
    
    pbuy = @process.get_campaign.pointbuy
    pointbuy_counter = labels[0]
    pointbuy_counter.width_chars = 6
    
    if pbuy.integer?
      set_point_buy_label(pointbuy_counter, pbuy, @process.get_stat_pointbuy)
    end    

    (1..6).each do |x|
      spin_entries[x].signal_connect("changed") {@process.set_base_stat(x-1,spin_entries[x].value)}
      spin_entries[x].signal_connect("changed") {total_entries[x].signal_emit("changed")}      
      spin_entries[x].signal_connect("changed") {
      if @process.get_campaign.pointbuy.integer?
        set_point_buy_label(pointbuy_counter, @process.get_campaign.pointbuy, @process.get_stat_pointbuy)        
      else
        pointbuy_counter.text = ""
      end
      }
      
      race_entries[x].signal_connect("changed") {race_entries[x].text = @process.get_race_stat(x-1).to_s}
      race_entries[x].signal_connect("changed") {total_entries[x].signal_emit("changed")}
      
      misc_entries[x].signal_connect("changed") {@process.set_misc_stat(x-1, misc_entries[x].text)}
      misc_entries[x].signal_connect("changed") {total_entries[x].signal_emit("changed")}
      
      total_entries[x].signal_connect("changed") {total_entries[x].text = @process.get_stat_total(x-1).to_s}
      total_entries[x].signal_connect("changed") {bonus_entries[x].signal_emit("changed")}
      
      bonus_entries[x].signal_connect("changed") {bonus_entries[x].text = total_entries[x].text.bonus}
    end
    
    labels.each_with_index { |entry, index| stats_box.attach(entry, 0, 1, index, index+1,        0, 0, 5, 0) }
    spin_entries.each_with_index { |entry, index| stats_box.attach(entry, 1, 2, index, index+1,  0, 0, 5, 0) }
    race_entries.each_with_index { |entry, index| stats_box.attach(entry, 2, 3, index, index+1,  0, 0, 5, 0) }
    misc_entries.each_with_index { |entry, index| stats_box.attach(entry, 3, 4, index, index+1,  0, 0, 5, 0) }
    total_entries.each_with_index { |entry, index| stats_box.attach(entry, 4, 5, index, index+1, 0, 0, 5, 0) }
    bonus_entries.each_with_index { |entry, index| stats_box.attach(entry, 5, 6, index, index+1, 0, 0, 5, 0) }
    stats_box.focus_chain = spin_entries[1..6]
  end
  
  def set_point_buy_label (pointbuy_counter, pointbuy_limit, pointbuy_val)    
    pointbuy_limit = pointbuy_limit.to_i
    color = "blue"
    display_val = pointbuy_val.nil? ? "**" : pointbuy_val.to_s
    if pointbuy_val.nil?
      color = "pink"
    elsif pointbuy_val == pointbuy_limit
      color = "green"
    elsif pointbuy_val > pointbuy_limit
      color = "red"
    end          
    pointbuy_counter.set_markup("<span foreground=\"#{color}\">#{display_val}/#{pointbuy_limit.to_s}</span>")
  end
  
  def build_alt_traits_row(trait_row)
    trait_store = @process.get_race_trait_store()
    race_list_view = Gtk::TreeView.new(trait_store)
    race_list_view.selection.mode = Gtk::SELECTION_SINGLE

    # Create a renderer
    renderer = Gtk::CellRendererText.new
    # Add column using our renderer
    col = Gtk::TreeViewColumn.new("Racial Traits", renderer, :text => 0)
    race_list_view.append_column(col)
    
    #scrolled_win = Gtk::ScrolledWindow.new
    #scrolled_win.add(race_list_view)
    #scrolled_win.set_policy(Gtk::POLICY_AUTOMATIC, Gtk::POLICY_AUTOMATIC)
    #trait_row.pack_start(scrolled_win, false, false, 2)
    trait_row.pack_start(race_list_view, false, false, 2)
    
    button_col = Gtk::VBox.new(homogenous =false, spacing = nil)
    add_but = Gtk::Button.new("<<")
    remove_but = Gtk::Button.new(">>")
    
    button_col.pack_start(add_but, false, false, 2)
    button_col.pack_start(remove_but, false, false, 2)
    trait_row.pack_start(button_col, false, false, 2)
  
    alt_trait_store = @process.get_alt_race_trait_store()
    list_view = Gtk::TreeView.new(alt_trait_store)
    list_view.selection.mode = Gtk::SELECTION_SINGLE

    # Create a renderer
    renderer = Gtk::CellRendererText.new
    # Add column using our renderer
    col = Gtk::TreeViewColumn.new("Alternate Traits", renderer, :text => 0)
    list_view.append_column(col)
    
    #scrolled_win = Gtk::ScrolledWindow.new
    #scrolled_win.add(list_view)
    #scrolled_win.set_policy(Gtk::POLICY_AUTOMATIC, Gtk::POLICY_AUTOMATIC)
    #trait_row.pack_start(scrolled_win, false, false, 2)
    trait_row.pack_start(list_view, false, false, 2)
  end
  
  def build_race_box(race_box)  
    race_row = Gtk::HBox.new(homogenous =false, spacing = nil)    
    @optional_stat_rows = Gtk::VBox.new(homogenous =false, spacing = nil)    
    
    
    race_label = Gtk::Label.new("Race:")
    race_entry = Gtk::ComboBox.new(is_text_only = true)   
    @process.get_races.keys.each_with_index do |race_text, index|
      race_entry.append_text(race_text)
      race_entry.set_active(index) if race_text == @char.race
    end
    
    race_entry.signal_connect("changed") { |e| @process.set_race_stats(e.active_text)}
    race_entry.signal_connect("changed") { update_race_stats }
    race_entry.signal_connect("changed") { |e| setup_optional_stats(e.active_text) }
    
    if( not @char.race.nil?)
      setup_optional_stats @char.race
    end
    
    race_row.pack_start(race_label, false, false, 2)
    race_row.pack_start(race_entry, false, false, 2)
    
    race_box.pack_start(race_row, false, false, 2)
    race_box.pack_start(@optional_stat_rows, false, false, 2)
  end
  
  def update_race_stats
    @races.each {|x| x.signal_emit("changed") }  
  end
  
  def setup_optional_stats (race)
    @optional_stat_rows.each { |child| child.destroy}
    choices = @process.get_race_optionals(race);
    @log.debug {"stat choices for #{race} are #{choices}" }
    return if choices.nil?
    attribs = @process.get_attribute_names
    choices.times do |x|
      choice_row = Gtk::HBox.new(homogenous =false, spacing = nil)
      stat_label = Gtk::Label.new("Stat Boost:")
      stat_entry = Gtk::ComboBox.new(is_text_only = true)   
      attribs.each_with_index do |stat_text, index|
        stat_entry.append_text(stat_text)
        if not @char.optionals.nil? and @char.optionals[x] == stat_text
          stat_entry.set_active(index) 
        end
      end
      choice_row.pack_start(stat_label, false, false, 0)
      choice_row.pack_start(stat_entry, false, false, 0)
      
      stat_entry.signal_connect("changed") { |e| @process.set_optionals(e.active_text, x)}
      stat_entry.signal_connect("changed") { update_race_stats }
      
      @optional_stat_rows.pack_start(choice_row, false, false, 0)
    end
    @optional_stat_rows.show_all
  end
  
end