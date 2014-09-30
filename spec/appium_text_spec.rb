require 'spec_helper'

describe Cuesmash::AppiumText do

  describe "when creating a new instance" do
    before(:all) do
      @appiumtext = Cuesmash::AppiumText.new(platform_name: "iOS", device_name: "iPhone Simulator", platform_version: "7.1", app: "MyApp")
    end

    it "should have a platform name" do
      expect(@appiumtext.platform_name).to match("iOS")
    end

    it "should have a device name" do
      expect(@appiumtext.device_name).to match("iPhone Simulator")
    end

    it "should have a platform_version" do
      expect(@appiumtext.platform_version).to match("7.1")
    end

    it "should have an app name" do
      expect(@appiumtext.app).to match("MyApp")
    end
  end
end
