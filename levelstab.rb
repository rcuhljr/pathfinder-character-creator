class LevelsTab
  def initialize(logger, process)
    @log = logger
    @process = process;
  end

# build the race and stats tab
  
  def build_levels(tab_holder)
    @char = @process.get_character
    tab_label = Gtk::Label.new("Levels")    
    
    levels_box = Gtk::VBox.new(homogeneous = false, spacing = 5)
    level_stack = Gtk::VBox.new(homogeneous = false, spacing = 5)
        
    build_level_rows(level_stack)
    
    levels_box.pack_start(level_stack, false, false, 0)
            
    tab_holder.append_page(levels_box, tab_label)    
  end
  
  def build_level_rows(level_stack)
    (1..20).each do |x|
        level_row = Gtk::HBox.new(homogeneous = false, spacing = 5)
        level_row.pack_start(Gtk::Label.new(x.to_s), false, false, 0)
        
        level_stack.pack_start(level_row, false, false, 2)
    end    
  end
end