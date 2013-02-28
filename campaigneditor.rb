class CampaignEditor
  def initialize(logger, process)
    @log = logger
    @process = process;
  end
  
  def build_campaign_editor
    @camp = @process.get_campaign
    content_box = Gtk::VBox.new(homogeneous = false, spacing = nil)
    
    header_row = build_header_row
    
    content_box.pack_start(header_row, false, false, 2)
  
    return content_box
  end  
  
  def build_header_row
    header_row = Gtk::VBox.new(homogeneous = false, spacing = nil)
    
    name_label = Gtk::Label.new("Campaign Name:")
    name_entry = Gtk::Entry.new()
    name_entry.text = @camp.name unless @camp.name.nil?
    
    pointbuy_label = Gtk::Label.new("Point Buy:")
    pointbuy_entry = Gtk::ComboBox.new(is_text_only = true)   
    @process.get_pointbuys.each_with_index do |pbuy_text, index|
      pointbuy_entry.append_text(pbuy_text.to_s)
      pointbuy_entry.set_active(index) if pbuy_text.to_s == @camp.pointbuy.to_s
    end
    
    header_row.pack_start(name_label, false, false, 2)
    header_row.pack_start(name_entry, false, false, 2)
    header_row.pack_start(pointbuy_label, false, false, 2)
    header_row.pack_start(pointbuy_entry, false, false, 2)
    
    name_entry.signal_connect("changed") { |e| @process.set_camp_name(e.text) }    
    pointbuy_entry.signal_connect("changed") { |e| @process.set_pointbuy(e.active_text) }
  
    return header_row
  end
end