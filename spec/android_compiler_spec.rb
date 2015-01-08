require 'spec_helper'
require 'cuesmash/android_compiler'

describe Cuesmash::AndroidCompiler do

  before(:each) do
    Cuesmash::AndroidCompiler.any_instance.stub(:puts)
  end

  describe "when generating the command" do

    before(:each) do
      @compiler = Cuesmash::AndroidCompiler.new(project_name: nil, build_configuration: nil)
    end

  end # "when generating the command"

  describe "when compiling" do

    before(:each) do
      wait = double
      @value = double
      wait.stub(:value){@value}
      wait.stub(:join)
      Open3.stub(:popen3).and_yield(nil, nil, nil, wait)

      @compiler = Cuesmash::AndroidCompiler.new(project_name: nil, build_configuration: nil)
    end # before

    it "should complete if all is well" do
      @value.stub(:exitstatus){0}
      @compiler.compile do |complete|
        expect(complete).to equal(true)
      end
    end # "should complete if all is well" 
  end # "when compiling"
end # describe Cuesmash::AndroidCompiler
