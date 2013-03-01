load '../utilities.rb'

describe String, "#integer?" do
  it "returns true for string consisting of an int" do
    a_string = "1"
    a_string.should be_integer
  end
end

describe String, "#integer?" do
  it "returns false for string consisting of a decimal" do
    a_string = "1.5"
    a_string.should_not be_integer
  end
end

describe String, "#integer?" do
  it "returns false for string consisting of non numerics" do
    a_string = "Test"
    a_string.should_not be_integer
  end
end

describe String, "#integer?" do
  it "returns false for string consisting of mixed" do
    a_string = "Test 15"
    a_string.should_not be_integer
  end
end

describe String, "#bonus" do
  it "returns +1 for string consisting of 12" do
    a_string = "12"
    a_string.bonus.should eq("+1")
  end
end

describe String, "#bonus" do
  it "returns +0 for string consisting of 10" do
    a_string = "10"
    a_string.bonus.should eq("+0")
  end
end

describe String, "#bonus" do
  it "returns -2 for string consisting of 6" do
    a_string = "6"
    a_string.bonus.should eq("-2")
  end
end