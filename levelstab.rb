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

# Controls creation and management of 

class LevelsTab
  def initialize(logger, process)
    @log = logger
    @process = process;
  end

# build the race and stats tab
  
  def build_levels(tab_holder)
    @char = @process.get_character
    tab_label = Gtk::Label.new("Levels")

    levels_box = Gtk::HBox.new(homogeneous = false, spacing = 5)
    level_stack = Gtk::VBox.new(homogeneous = false, spacing = 5)

    build_level_rows(level_stack)

    levels_box.pack_start(level_stack, false, false, 0)

    tab_holder.append_page(levels_box, tab_label)
  end
  
  def build_level_rows(level_stack)
    (1..20).each do |x|      
      level_row = Gtk::HBox.new(homogeneous = false, spacing = 5)
      level_row.pack_start(Gtk::Label.new(x.to_s), false, false, 0)
      
      level_entry = Gtk::ComboBox.new(is_text_only = true)
      @process.get_class_names.each_with_index do |level_text, index|
        level_entry.append_text(level_text)
        level_entry.set_active(index) if level_text == @char.levels[x]
      end
      level_row.pack_start(level_entry, false, false, 0)
      
      level_stack.pack_start(level_row, false, false, 2)
    end
  end
end