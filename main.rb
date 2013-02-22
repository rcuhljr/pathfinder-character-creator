# A pathfinder character creation utility
# Author:: Robert Uhl (mailto:uhlrc@yahoo.com)
# License:: MIT License

require 'gtk2'
require 'logger'
load 'datamanager.rb'
load 'logicprocess.rb'

# Main GUI for the program, contains all of our UI code.

class Main
  
  # Creates our LogicProcess and main window before kicking off the main event loop. 
  
  def initialize
    @log = Logger.new(STDOUT)
    @log.level = Logger::DEBUG
    @process = LogicProcess.new
  
    @window = Gtk::Window.new("Pathfinder Character Utility")
    @window.set_default_size(800, 600)    
    @window.signal_connect("destroy") {
      @log.info "destroy event occurred"
      Gtk.main_quit
    }
    
    @menu_bar = setup_menus
    
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
    
    newchar.signal_connect('activate') { new_character }
    openchar.signal_connect('activate') { open_character }    
    
    filemenu.append(newchar)
    filemenu.append(openchar)
    
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
    
    name_label = Gtk::Label.new("Character Name:")
    name_entry = Gtk::Entry.new
    
    player_label = Gtk::Label.new("Player Name:")
    player_entry = Gtk::Entry.new
    
    @main_content.pack_start_defaults(name_label)  
    @main_content.pack_start_defaults(name_entry)
    @main_content.pack_start_defaults(player_label)
    @main_content.pack_start_defaults(player_entry)
    
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
  end
  
  def save_prompt
    #ask to save current character.
  end
end

