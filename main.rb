# A pathfinder character creation utility
# Author:: Robert Uhl (mailto:uhlrc@yahoo.com)
# License:: MIT License

require 'gtk2'
require 'logger'
load 'datamanager.rb'
load 'logicprocess.rb'
load 'racestatstab.rb'

# Main GUI for the program, contains all of our UI code.

class Main
  
  # Creates our LogicProcess and main window before kicking off the main event loop. 
  
  def initialize(logger)
    @log = logger
    @process = LogicProcess.new(@log)
  
    @window = Gtk::Window.new("Pathfinder Character Utility")
    @window.set_default_size(800, 600)    
    @window.signal_connect("destroy") {
      @log.info "destroy event occurred"
      Gtk.main_quit
    }
    
    @menu_bar = setup_menus
    
    @char_file_filter = Gtk::FileFilter.new
    @char_file_filter.add_pattern("*.pcf")
    @race_stats_tab = RaceStatsTab.new(@log, @process)
    
    content = Gtk::VBox.new(homogeneous = false, spacing = nil)
    @main_content = Gtk::VBox.new(homogeneous = false, spacing = nil)
    content.pack_start(@menu_bar, false, false, 0)
    content.pack_start(@main_content, true, true, 0)
    @window.add(content)
    @window.show_all
    
    Gtk.main
  end
  
  # Creates and adds the menubar to the main window.
  
  def setup_menus
    menubar = Gtk::MenuBar.new
    file = Gtk::MenuItem.new("File")
    
    filemenu = Gtk::Menu.new
    
    file.submenu = filemenu
    
    menubar.append(file)   
    
    group = Gtk::AccelGroup.new
    
    newchar = Gtk::ImageMenuItem.new(Gtk::Stock::NEW, group)
    openchar = Gtk::ImageMenuItem.new(Gtk::Stock::OPEN, group)
    savechar = Gtk::ImageMenuItem.new(Gtk::Stock::SAVE, group)
    
    newchar.signal_connect('activate') { new_character }
    openchar.signal_connect('activate') { open_character }    
    savechar.signal_connect('activate') { save_character }  
    
    filemenu.append(newchar)
    filemenu.append(openchar)
    filemenu.append(savechar)
    
    @window.add_accel_group(group)
    
    return menubar
  end
  
  # Removes the existing character view and builds a new one from the data provided by the process object.  
  #--
  # Might need to split this into a create_view and reset_view methodolgy based on how slow wiping out and recreating it proves to be.
  #++
  
  def reset_view
    @log.debug ("reset_view")
    char = @process.get_character
    
    @main_content.each { |child| child.destroy}
    
    tab_holder = Gtk::Notebook.new
    
    @race_stats_tab.build_race_stats(tab_holder, char)
    
    tab_holder.append_page(Gtk::Label.new("Lorem Ipsum"), Gtk::Label.new("Other"))
    
    @main_content.pack_start(tab_holder, false, false, 0)
    
    @main_content.show_all
  end
  
  # method for handling the new character menu option and key shortcuts.
  
  def new_character    
    @log.debug ("new_character")
    if @process.unsaved_changes? then
        save_prompt
    end
    @process.new_character
    reset_view 
  end
  
  def open_character
    #todo check for saving current character, load in data file.
    @log.debug ( "open_character"  )
    dialog = Gtk::FileChooserDialog.new("Open Character",
      @window, 
      Gtk::FileChooser::ACTION_OPEN, 
      nil, 
      [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_CANCEL],
      [Gtk::Stock::OPEN, Gtk::Dialog::RESPONSE_ACCEPT])
        
    dialog.set_filter(@char_file_filter)
    if dialog.run == Gtk::Dialog::RESPONSE_ACCEPT
      @process.open_character(dialog.filename)            
      reset_view
    end
    dialog.destroy    
  end
  
  def save_character
    @log.debug { "Saving character"}        
    char = @process.get_character
    dialog = Gtk::FileChooserDialog.new("Save Character",
      @window, 
      Gtk::FileChooser::ACTION_SAVE, 
      nil, 
      [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_CANCEL],
      [Gtk::Stock::SAVE, Gtk::Dialog::RESPONSE_ACCEPT])
    
    dialog.set_current_name(char.name.delete(" ")+".pcf")
    dialog.set_filter(@char_file_filter)
    if dialog.run == Gtk::Dialog::RESPONSE_ACCEPT
      @process.save_character(dialog.filename)
    end
    dialog.destroy
  end
  
  def save_prompt
    #ask to save current character.
  end
end

