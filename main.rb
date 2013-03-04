# A pathfinder character creation utility
# Author:: Robert Uhl (mailto:uhlrc@yahoo.com)
# License:: MIT License

require 'gtk2'
require 'logger'
load 'datamanager.rb'
load 'logicprocess.rb'
load 'racestatstab.rb'
load 'campaigneditor.rb'
load 'levelstab.rb'

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
    
    @camp_file_filter = Gtk::FileFilter.new
    @camp_file_filter.add_pattern("*.pcs")
    
    @race_stats_tab = RaceStatsTab.new(@log, @process)
    @levels_tab = LevelsTab.new(@log, @process)
    @campaign_editor = CampaignEditor.new(@log, @process)
    
    content = Gtk::VBox.new(homogeneous = false, spacing = nil)
    @main_content = Gtk::VBox.new(homogeneous = false, spacing = nil)
    content.pack_start(@menu_bar, false, false, 0)
    content.pack_start(@main_content, true, true, 0)
    @window.add(content)
    @window.show_all
    
    Gtk.main
  end
  
  def create_campaign_window
    @log.debug("Create Campaign Window")
    if not @campaign_window.nil?
      return
    end    
    @campaign_window = Gtk::Window.new("Pathfinder Campaign Settings")
    @campaign_window.set_default_size(800, 600)    
    @campaign_window.signal_connect("destroy") {
      @log.info "destroy campaign event occurred"   
      @campaign_window = nil
      reset_view
    }
    
    @campaign_window.add(@campaign_editor.build_campaign_editor)
    
    
    @campaign_window.show_all
    @campaign_window.keep_above = true
    
  end
  
  # Creates and adds the menubar to the main window.
  
  def setup_menus        
    menubar = Gtk::MenuBar.new
    group = Gtk::AccelGroup.new
    
    menubar.append(setup_character_menu(group))   
    menubar.append(setup_campaign_menu(group))
    
    @window.add_accel_group(group)
    return menubar
  end
  
  def setup_character_menu(group)
        
    character = Gtk::MenuItem.new("Character")    
    charmenu = Gtk::Menu.new        
    character.submenu = charmenu
    
    newchar = Gtk::ImageMenuItem.new(Gtk::Stock::NEW, group)
    openchar = Gtk::ImageMenuItem.new(Gtk::Stock::OPEN, group)
    savechar = Gtk::ImageMenuItem.new(Gtk::Stock::SAVE, group)
    
    newchar.signal_connect('activate') { new_character }
    openchar.signal_connect('activate') { open_character }    
    savechar.signal_connect('activate') { save_character }  
    
    charmenu.append(newchar)
    charmenu.append(openchar)
    charmenu.append(savechar)
    
    return character
  end
  
  def setup_campaign_menu(group)
        
    campaign = Gtk::MenuItem.new("Campaign")    
    campmenu = Gtk::Menu.new        
    campaign.submenu = campmenu
    
    newcamp = Gtk::MenuItem.new("New Campaign", group)    
    opencamp = Gtk::MenuItem.new("Open Campaign", group)
    savecamp = Gtk::MenuItem.new("Save Campaign", group)
    editcamp = Gtk::MenuItem.new("Edit Campaign", group)
        
    newcamp.add_accelerator('activate', group, Gdk::Keyval::GDK_N, Gdk::Window::MOD1_MASK, Gtk::ACCEL_VISIBLE)
    opencamp.add_accelerator('activate', group, Gdk::Keyval::GDK_O, Gdk::Window::MOD1_MASK, Gtk::ACCEL_VISIBLE)
    savecamp.add_accelerator('activate', group, Gdk::Keyval::GDK_S, Gdk::Window::MOD1_MASK, Gtk::ACCEL_VISIBLE)
    editcamp.add_accelerator('activate', group, Gdk::Keyval::GDK_E, Gdk::Window::MOD1_MASK, Gtk::ACCEL_VISIBLE)
    
    newcamp.signal_connect('activate') { new_campaign }
    opencamp.signal_connect('activate') { open_campaign }    
    savecamp.signal_connect('activate') { save_campaign }  
    editcamp.signal_connect('activate') { edit_campaign }  
    
    campmenu.append(newcamp)
    campmenu.append(opencamp)
    campmenu.append(savecamp)
    campmenu.append(editcamp)
    
    return campaign

  end
  
  def edit_campaign
    @log.debug {"Edit Campaign"}
    create_campaign_window
  end
  
  # Removes the existing character view and builds a new one from the data provided by the process object.  
  #--
  # Might need to split this into a create_view and reset_view methodolgy based on how slow wiping out and recreating it proves to be.
  #++
  
  def reset_view
    @log.debug ("reset_view")    
    
    @main_content.each { |child| child.destroy}
    
    tab_holder = Gtk::Notebook.new
    
    @race_stats_tab.build_race_stats(tab_holder)
    
    @levels_tab.build_levels(tab_holder)
    
    @main_content.pack_start(tab_holder, false, false, 0)
    
    @main_content.show_all
  end
  
  # method for handling the new character menu option and key shortcuts.
  
  def new_character    
    @log.debug ("new_character")
    if @process.has_unsaved_changes? then
        prompt_save_character
    end
    @process.new_character
    reset_view 
  end
  
  def new_campaign
    @log.debug {"new_campaign"}
    if @process.has_unsaved_campaign_changes? then
      prompt_save_campaign
    end
    @process.new_campaign
    reset_view 
  end
  
  def prompt_save_character
    dialog = Gtk::MessageDialog.new(
      @window,
      Gtk::Dialog::MODAL,
      Gtk::MessageDialog::QUESTION,
      Gtk::MessageDialog::BUTTONS_YES_NO,
      "Unsaved Changes!"
    )
    dialog.secondary_text = "Would you like to save this character?"
    if dialog.run == Gtk::Dialog::RESPONSE_YES
      save_character
    end
    dialog.destroy
  end
  
  def prompt_save_campaign
    dialog = Gtk::MessageDialog.new(
      @window,
      Gtk::Dialog::MODAL,
      Gtk::MessageDialog::QUESTION,
      Gtk::MessageDialog::BUTTONS_YES_NO,
      "Unsaved Changes!"
    )
    dialog.secondary_text = "Would you like to save this Campaign?"
    if dialog.run == Gtk::Dialog::RESPONSE_YES
      save_campaign
    end
    dialog.destroy
  end
  
  def open_character
    @log.debug ( "open_character"  )
    
    if @process.has_unsaved_changes? then
        prompt_save_character
    end
    
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
  
  def open_campaign
    @log.debug {"Open Campaign"}
    
    if @process.has_unsaved_campaign_changes? then
      prompt_save_campaign
    end
    dialog = Gtk::FileChooserDialog.new("Open Campaign",
      @window, 
      Gtk::FileChooser::ACTION_OPEN, 
      nil, 
      [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_CANCEL],
      [Gtk::Stock::OPEN, Gtk::Dialog::RESPONSE_ACCEPT])
        
    dialog.set_filter(@camp_file_filter)
    if dialog.run == Gtk::Dialog::RESPONSE_ACCEPT
      @process.open_campaign(dialog.filename)            
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
    if char.file_name.nil?
      charname = char.name.nil? ? "character" : char.name
      dialog.set_current_name(charname.delete(" ")+".pcf")
    else
      dialog.set_current_name(char.file_name)
    end
    dialog.set_filter(@char_file_filter)
    if dialog.run == Gtk::Dialog::RESPONSE_ACCEPT
      @process.save_character(dialog.filename)
    end
    dialog.destroy
  end
  
    
  def save_campaign
    @log.debug {"Save Campaign"}
    camp = @process.get_campaign
    dialog = Gtk::FileChooserDialog.new("Save Campaign",
      @window, 
      Gtk::FileChooser::ACTION_SAVE, 
      nil, 
      [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_CANCEL],
      [Gtk::Stock::SAVE, Gtk::Dialog::RESPONSE_ACCEPT])
    if camp.file_name.nil?
      campname = camp.name.nil? ? "campaign" : camp.name
      dialog.set_current_name(campname.delete(" ")+".pcs")
    else
      dialog.set_current_name(camp.file_name)
    end
    dialog.set_filter(@camp_file_filter)
    if dialog.run == Gtk::Dialog::RESPONSE_ACCEPT
      @process.save_campaign(dialog.filename)
    end
    dialog.destroy	
  end

end

