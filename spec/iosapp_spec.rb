require 'spec_helper'

describe Cuesmash::IosApp do
  describe "when creating a new instance" do
    before(:all) do
      Dir.stub(:mktmpdir) { "/tmp" }
      @iosapp = Cuesmash::IosApp.new(file_name: "MyApp")
    end

    it "should have an app_dir instance" do
      @iosapp.app_dir.should match("/tmp/Build/Products/Debug-iphonesimulator/")
    end

    it "should have an app_path instance" do
      @iosapp.app_path.should match("/tmp/Build/Products/Debug-iphonesimulator/MyApp.app")
    end

    it "should have a tmp_dir instance" do
      @iosapp.tmp_dir.should match("/tmp")
    end

    it "should have an app_name instance" do
      @iosapp.app_name.should match("MyApp.app")
    end
  end
end
