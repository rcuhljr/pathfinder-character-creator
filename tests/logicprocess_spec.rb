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
