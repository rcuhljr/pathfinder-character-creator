require_relative '../logicprocess.rb'
require 'rspec'

describe LogicProcess, "#has_unsaved_changes?" do
  let(:logger) { double("Logger").as_null_object }
  let(:dc) { double("DataContainer").as_null_object }  
  it "returns false if character is identical to a new character" do    
    logic = LogicProcess.new(logger, {:dc => dc})
    logic.new_character
    logic.should_not have_unsaved_changes
  end
end

describe LogicProcess, "#has_unsaved_changes?" do
  let(:logger) { double("Logger").as_null_object }
  let(:dc) { double("DataContainer").as_null_object }  
  it "returns true if character is different and file name is nil" do
    logic = LogicProcess.new(logger, {:dc => dc})
    logic.set_name("fred")
    logic.should have_unsaved_changes
  end
end

describe LogicProcess, "#has_unsaved_changes?" do
  let(:logger) { double("Logger").as_null_object }
  let(:dc) { double("DataContainer").as_null_object }  
  let(:dm) {double("DataManager") }
  it "returns false if character is the same as character on disk" do
    logic = LogicProcess.new(logger, {:dm => dm, :dc=> dc})
    logic.set_name("fred")
    logic.get_character.file_name = "fred.pfc"    
    dm.should_receive(:load).with("fred.pfc").once {OpenStruct.new(logic.get_character.marshal_dump)}
    logic.should_not have_unsaved_changes
  end
end

describe LogicProcess, "#has_unsaved_changes?" do
  let(:logger) { double("Logger").as_null_object }
  let(:dc) { double("DataContainer").as_null_object }  
  let(:dm) {double("DataManager") }
  it "returns true if character is not the same as character on disk" do
    logic = LogicProcess.new(logger, {:dm => dm, :dc=> dc})
    logic.set_name("fred")
    logic.get_character.file_name = "fred.pfc"    
    oldchar = OpenStruct.new(logic.get_character.marshal_dump)
    dm.should_receive(:load).with("fred.pfc").once {oldchar}
    logic.set_name("joe")
    logic.should have_unsaved_changes
  end
end

describe LogicProcess, "#has_unsaved_campaign_changes?" do
  let(:logger) { double("Logger").as_null_object }
  let(:dc) { double("DataContainer").as_null_object }  
  it "returns false if campaign is identical to a new campaign" do    
    logic = LogicProcess.new(logger, {:dc => dc})
    logic.new_campaign
    logic.should_not have_unsaved_campaign_changes
  end
end

describe LogicProcess, "#has_unsaved_campaign_changes?" do
  let(:logger) { double("Logger").as_null_object }
  let(:dc) { double("DataContainer").as_null_object }  
  it "returns true if campaign is different and file name is nil" do
    logic = LogicProcess.new(logger, {:dc => dc})
    logic.set_camp_name("fred")
    logic.should have_unsaved_campaign_changes
  end
end

describe LogicProcess, "#has_unsaved_campaign_changes?" do
  let(:logger) { double("Logger").as_null_object }
  let(:dc) { double("DataContainer").as_null_object }  
  let(:dm) {double("DataManager") }
  it "returns false if campaign is the same as campaign on disk" do
    logic = LogicProcess.new(logger, {:dm => dm, :dc=> dc})
    logic.set_camp_name("fred's campaign")
    logic.get_campaign.file_name = "freds.pcs"    
    dm.should_receive(:load).with("freds.pcs").once {OpenStruct.new(logic.get_campaign.marshal_dump)}
    logic.should_not have_unsaved_campaign_changes
  end
end

describe LogicProcess, "#has_unsaved_campaign_changes?" do
  let(:logger) { double("Logger").as_null_object }
  let(:dc) { double("DataContainer").as_null_object }  
  let(:dm) {double("DataManager") }
  it "returns true if campaign is not the same as campaign on disk" do
    logic = LogicProcess.new(logger, {:dm => dm, :dc=> dc})
    logic.set_camp_name("fred's campaign")
    logic.get_campaign.file_name = "freds.pcs"    
    oldcamp = OpenStruct.new(logic.get_campaign.marshal_dump)
    dm.should_receive(:load).with("freds.pcs").once {oldcamp}
    logic.set_camp_name("joe's campaign")
    logic.should have_unsaved_campaign_changes
  end
end

describe LogicProcess, "#new_character" do
  let(:logger) { double("Logger").as_null_object }
  let(:dc) { double("DataContainer").as_null_object }  
  let(:dm) {double("DataManager") }
  it "resets the processes character to a new object" do
    logic = LogicProcess.new(logger, {:dm => dm, :dc=> dc})    
    old_char = logic.get_character
    logic.new_character
    logic.get_character.should_not.equal? old_char
  end
end

describe LogicProcess, "#new_campaign" do
  let(:logger) { double("Logger").as_null_object }
  let(:dc) { double("DataContainer").as_null_object }  
  let(:dm) {double("DataManager") }
  it "resets the campaign object to the default" do
    logic = LogicProcess.new(logger, {:dm => dm, :dc=> dc})    
    old_camp = logic.get_campaign
    logic.new_campaign
    logic.get_campaign.should_not.equal? old_camp
  end
end

describe LogicProcess, "#save_character" do
  let(:logger) { double("Logger").as_null_object }
  let(:dc) { double("DataContainer").as_null_object }  
  let(:dm) {double("DataManager") }
  it "save sets the character file name" do     
    logic = LogicProcess.new(logger, {:dm => dm, :dc=> dc})    
    dm.should_receive(:save_character).with("test.blah", kind_of(OpenStruct)).once
    logic.save_character("test.blah")    
    logic.get_character.file_name.should eq "test.blah"
  end
end

describe LogicProcess, "#save_campaign" do
  let(:logger) { double("Logger").as_null_object }
  let(:dc) { double("DataContainer").as_null_object }  
  let(:dm) {double("DataManager") }
  it "save sets the campaign file name" do
    logic = LogicProcess.new(logger, {:dm => dm, :dc=> dc})    
    dm.should_receive(:save_campaign).with("test.blah", kind_of(OpenStruct)).once
    logic.save_campaign("test.blah")    
    logic.get_campaign.file_name.should eq "test.blah"
  end
end

describe LogicProcess, "#get_stat_total" do
  let(:logger) { double("Logger").as_null_object }
  let(:dc) { double("DataContainer").as_null_object }  
  let(:dm) {double("DataManager") }
  it "returns the sum of all stats in the index specified" do
    logic = LogicProcess.new(logger, {:dm => dm, :dc=> dc})    
    logic.set_base_stat(2,9)
    logic.set_race_stat(2,2)
    logic.set_misc_stat(2,3)
    logic.get_stat_total(2).should be 14
  end
end

describe LogicProcess, "#get_stat_pointbuy" do
  let(:logger) { double("Logger").as_null_object }
  let(:dc) { double("DataContainer").as_null_object }  
  let(:dm) {double("DataManager") }
  it "calculates the stat point buy" do
    logic = LogicProcess.new(logger, {:dm => dm, :dc=> dc})    
    logic.set_base_stat(0,12)    
    logic.get_stat_pointbuy().should be 2
  end
end

describe LogicProcess, "#get_stat_pointbuy" do
  let(:logger) { double("Logger").as_null_object }
  let(:dc) { double("DataContainer").as_null_object }  
  let(:dm) {double("DataManager") }
  it "returns nil if any stat is outside defined range" do
    logic = LogicProcess.new(logger, {:dm => dm, :dc=> dc})    
    logic.set_base_stat(3,19)    
    logic.get_stat_pointbuy().should be nil
  end
end

describe LogicProcess, "#set_race_stats" do
  let(:logger) { double("Logger").as_null_object }
  let(:dc) { double("DataContainer").as_null_object }  
  let(:dm) {double("DataManager") }
  it "updates the race stat array with appropriate values" do
    logic = LogicProcess.new(logger, {:dm => dm, :dc=> dc})
    dc.should_receive(:get_race_stats).once { {"Elf" => [0,2,-2,2,0,0]} }
    logic.set_race_stats("Elf")    
    logic.get_character.race_attribute_scores.should eq( [0,2,-2,2,0,0] )
  end
end