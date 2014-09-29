require 'spec_helper'

describe Cuesmash::Compiler do

  before(:each) do
    Cuesmash::Compiler.any_instance.stub(:puts)
  end

  it "should have a scheme instance" do
    compiler = Cuesmash::Compiler.new("scheme", "/tmp")
    compiler.scheme.should match("scheme")
  end

  it "should have a tmp_dir instance" do
    compiler = Cuesmash::Compiler.new("scheme", "/tmp")
    compiler.tmp_dir.should match("/tmp")
  end

  describe "when generating the command" do

    before(:each) do
      Cuesmash::Compiler.any_instance.stub(:workspace)
      @compiler = Cuesmash::Compiler.new("test-scheme", "/tmp")
    end

    it "should contain the scheme" do
      @compiler.instance_eval{command}.should match(/test-scheme/)
    end

    it "should contain the tmp path" do
      @compiler.instance_eval{command}.should match(/tmp/)
    end
  end

  describe "when getting the workspacae" do

    before(:each) do
      @compiler = Cuesmash::Compiler.new(nil, "/tmp")
      Dir.stub(:[]){["workspace-file"]}
    end

    it "should get the workspace from the current directory" do
      @compiler.instance_eval{workspace}.should match(/workspace-file/)
    end
  end

  describe "when compiling" do

    before(:each) do
      wait = double
      @value = double
      wait.stub(:value){@value}
      wait.stub(:join)
      Open3.stub(:popen3).and_yield(nil, nil, nil, wait)

      @compiler = Cuesmash::Compiler.new(nil, "/tmp")
    end

    it "should complete if all is well" do
      @value.stub(:exitstatus){0}
      @compiler.compile do |complete|
        complete.should equal(true)
      end
    end
  end

end
