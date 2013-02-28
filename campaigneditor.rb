class CampaignEditor
  def initialize(logger, process)
    @log = logger
    @process = process;
  end
  
  def build_campaign_editor
    campaign = @process.get_campaign
    content_box = Gtk::VBox.new(homogeneous = false, spacing = nil)
  
  end  
end