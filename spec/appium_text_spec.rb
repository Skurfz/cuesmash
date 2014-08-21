require 'spec_helper'

describe Cuesmash::AppiumText do

  describe "when creating a new instance" do
    before(:all) do
      @appiumtext = Cuesmash::AppiumText.new(platform_name: "iOS", device_name: "iPhone Simulator", platform_version: "7.1", app: "MyApp")
    end

    it "should have a platform name" do
      @appiumtext.platform_name.should match("iOS")
    end

    it "should have a device name" do
      @appiumtext.device_name.should match("iPhone Simulator")
    end

    it "should have a platform_version" do
      @appiumtext.platform_version.should match("7.1")
    end

    it "should have an app name" do
      @appiumtext.app.should match("MyApp")
    end
  end
end
