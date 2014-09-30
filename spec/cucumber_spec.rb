require 'spec_helper'

describe Cuesmash::Cucumber do

  before(:each) do
    Cuesmash::Cucumber.any_instance.stub(:puts)
  end

  describe "when running the tests" do

    before(:each) do
      wait = double
      @value = double
      wait.stub(:value){@value}
      wait.stub(:join)
      Open3.stub(:popen3).and_yield(nil, nil, nil, wait)

      @cucumber = Cuesmash::Cucumber.new(nil, nil)
      @cucumber.stub(:command)
    end

    it "should complete if all is well" do
      @value.stub(:exitstatus){0}
      @cucumber.should_receive(:completed)
      @cucumber.test
    end
  end

  describe "when generating the command" do

    it "should add the ios version" do
      @cucumber = Cuesmash::Cucumber.new("7.0", nil)
      @cucumber.stub(:tag_arguments)

      expect(@cucumber.instance_eval{command}).to match(/DEVICE_TARGET='iPhone Retina \(4-inch\) - Simulator - iOS 7.0'/)
    end

    it "should not add the ios version if missing" do
      @cucumber = Cuesmash::Cucumber.new(nil, nil)
      @cucumber.stub(:tag_arguments)

      expect(@cucumber.instance_eval{command}).not_to match(/DEVICE_TARGET/)
    end

    it "should add the format" do
      @cucumber = Cuesmash::Cucumber.new(nil, nil)
      @cucumber.format = "test-format"

      expect(@cucumber.instance_eval{command}).to match(/--format test-format/)
    end

    it "should not add the format if missing" do
      @cucumber = Cuesmash::Cucumber.new(nil, nil)

      expect(@cucumber.instance_eval{command}).not_to match(/--format/)
    end

    it "should add the output" do
      @cucumber = Cuesmash::Cucumber.new(nil, nil)
      @cucumber.output = "test-output"

      expect(@cucumber.instance_eval{command}).to match(/--out test-output/)
    end

    it "should not add the output if missing" do
      @cucumber = Cuesmash::Cucumber.new(nil, nil)

      expect(@cucumber.instance_eval{command}).not_to match(/--out/)
    end

    it "should add the tags" do
      @cucumber = Cuesmash::Cucumber.new(nil, ["tag1", "tag2"])
      expect(@cucumber.instance_eval{command}).to match(/--tags tag1 --tags tag2/)
    end

    it "should not add tags if missing" do
      @cucumber = Cuesmash::Cucumber.new(nil, nil)
      expect(@cucumber.instance_eval{command}).not_to match(/--tags/)
    end

    it "should add the color flag" do
      @cucumber = Cuesmash::Cucumber.new(nil, nil)
      expect(@cucumber.instance_eval{command}).to match(/-c/)
    end

  end
end
