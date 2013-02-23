class RaceStatsTab
  def initialize(logger, process)
    @log = logger
    @process = process;
  end

# build the race and stats tab
  
  def build_race_stats(tab_holder, char)
    tab_label = Gtk::Label.new("Race & Stats")    
    
    race_stats_box = Gtk::VBox.new(homogeneous = false, spacing = nil)
    header_row = Gtk::HBox.new(homogeneous = false, spacing = nil)
    stats_box = Gtk::Table.new(rows = 7, columns = 6, homogeneous = false)
    
    build_header_row(char, header_row)
    
    race_stats_box.pack_start(header_row, false, false, 0)
    
    build_stats_box(char, stats_box)
    
    race_stats_box.pack_start(stats_box, false, false, 10)
    
    tab_holder.append_page(race_stats_box, tab_label)    
  end
  
  def build_header_row(char, header_row)
    name_label = Gtk::Label.new("Character Name:")
    name_entry = Gtk::Entry.new()
    name_entry.text = char.name unless char.name.nil?
    
    player_label = Gtk::Label.new("Player Name:")
    player_entry = Gtk::Entry.new()
    player_entry.text = char.player unless char.player.nil?
    
    alignment_label = Gtk::Label.new("Alignment:")
    alignment_entry = Gtk::ComboBox.new(is_text_only = true)   
    @process.get_alignments.each_with_index do |align_text, index|
      alignment_entry.append_text(align_text)
      alignment_entry.set_active(index) if align_text == char.alignment
    end
    
    gender_label= Gtk::Label.new("Gender:")
    gender_entry = Gtk::ComboBox.new(is_text_only = true)   
    @process.get_genders.each_with_index do |gender_text, index|
      gender_entry.append_text(gender_text)
      gender_entry.set_active(index) if gender_text == char.gender
    end
    
    header_row.pack_start(name_label, false, false, 2)  
    header_row.pack_start(name_entry, false, false, 2)
    header_row.pack_start(player_label, false, false, 2)
    header_row.pack_start(player_entry, false, false, 2)
    header_row.pack_start(alignment_label, false, false, 2)
    header_row.pack_start(alignment_entry, false, false, 2)
    header_row.pack_start(gender_label, false, false, 2)
    header_row.pack_start(gender_entry, false, false, 2)
    
    name_entry.signal_connect("changed") { |e| char.name = e.text }
    player_entry.signal_connect("changed") { |e| char.player = e.text }
    alignment_entry.signal_connect("changed") { |e| char.alignment = e.active_text }
    gender_entry.signal_connect("changed") { |e| char.gender = e.active_text }
  end
  
  def build_stats_box(char, stats_box)
    
    spin_entries = []
    spin_entries.push(Gtk::Label.new("Score"))
    spin_entries.push(Gtk::SpinButton.new(3.0, 90.0, 1.0))
    spin_entries.push(Gtk::SpinButton.new(3.0, 90.0, 1.0))
    spin_entries.push(Gtk::SpinButton.new(3.0, 90.0, 1.0))
    spin_entries.push(Gtk::SpinButton.new(3.0, 90.0, 1.0))
    spin_entries.push(Gtk::SpinButton.new(3.0, 90.0, 1.0))
    spin_entries.push(Gtk::SpinButton.new(3.0, 90.0, 1.0))
    
    spin_entries.each { |entry| 
      next unless entry.is_a? Gtk::SpinButton
      entry.value = 10
    }
    
    labels = []
    labels.push(Gtk::Label.new(""))
    labels.push(Gtk::Label.new("STR"))
    labels.push(Gtk::Label.new("DEX"))
    labels.push(Gtk::Label.new("CON"))
    labels.push(Gtk::Label.new("INT"))
    labels.push(Gtk::Label.new("WIS"))
    labels.push(Gtk::Label.new("CHA"))
    
    race_entries = []
    race_entries.push(Gtk::Label.new("Race"))
    race_entries.push(Gtk::Entry.new())
    race_entries.push(Gtk::Entry.new())
    race_entries.push(Gtk::Entry.new())
    race_entries.push(Gtk::Entry.new())
    race_entries.push(Gtk::Entry.new())
    race_entries.push(Gtk::Entry.new())
    
    race_entries.each { |entry| 
      next unless entry.is_a? Gtk::Entry
      entry.editable = false
      entry.width_chars = 3
    }

    misc_entries = []
    misc_entries.push(Gtk::Label.new("Misc"))
    misc_entries.push(Gtk::Entry.new())
    misc_entries.push(Gtk::Entry.new())
    misc_entries.push(Gtk::Entry.new())
    misc_entries.push(Gtk::Entry.new())
    misc_entries.push(Gtk::Entry.new())
    misc_entries.push(Gtk::Entry.new())
    
    misc_entries.each { |entry| 
      next unless entry.is_a? Gtk::Entry
      entry.editable = false 
      entry.width_chars = 3
    }
    
    total_entries = []
    total_entries.push(Gtk::Label.new("Total"))
    total_entries.push(Gtk::Entry.new())
    total_entries.push(Gtk::Entry.new())
    total_entries.push(Gtk::Entry.new())
    total_entries.push(Gtk::Entry.new())
    total_entries.push(Gtk::Entry.new())
    total_entries.push(Gtk::Entry.new())
    
    total_entries.each { |entry| 
      next unless entry.is_a? Gtk::Entry
      entry.editable = false 
      entry.width_chars = 3
    }
    
    
    bonus_entries = []
    bonus_entries.push(Gtk::Label.new("Bonus"))
    bonus_entries.push(Gtk::Entry.new())
    bonus_entries.push(Gtk::Entry.new())
    bonus_entries.push(Gtk::Entry.new())
    bonus_entries.push(Gtk::Entry.new())
    bonus_entries.push(Gtk::Entry.new())
    bonus_entries.push(Gtk::Entry.new())
    
    bonus_entries.each { |entry| 
      next unless entry.is_a? Gtk::Entry
      entry.editable = false 
      entry.width_chars = 3
    }
    
    labels.each_with_index { |entry, index| stats_box.attach(entry, 0, 1, index, index+1,        0, 0, 5, 0) }
    spin_entries.each_with_index { |entry, index| stats_box.attach(entry, 1, 2, index, index+1,  0, 0, 5, 0) }
    race_entries.each_with_index { |entry, index| stats_box.attach(entry, 2, 3, index, index+1,  0, 0, 5, 0) }
    misc_entries.each_with_index { |entry, index| stats_box.attach(entry, 3, 4, index, index+1,  0, 0, 5, 0) }
    total_entries.each_with_index { |entry, index| stats_box.attach(entry, 4, 5, index, index+1, 0, 0, 5, 0) }
    bonus_entries.each_with_index { |entry, index| stats_box.attach(entry, 5, 6, index, index+1, 0, 0, 5, 0) }
    
  end

end