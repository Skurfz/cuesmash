require 'spec_helper'

describe Cuesmash::AppiumText do

  describe "when creating a new instance" do
    before(:all) do
      @appiumtext = Cuesmash::AppiumText.new(platform_name: "iOS", device_name: "iPhone Simulator", platform_version: "7.1", app: "MyApp", new_command_timeout: "90")
    end

    expected = "[caps]\nplatformName = \"iOS\"\ndeviceName = \"iPhone Simulator\"\nplatformVersion = \"7.1\"\napp = \"MyApp\"\nnewCommandTimeout = \"90\"\n"

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

    it "should have an newCommandTimeout" do
      expect(@appiumtext.new_command_timeout).to match("90")
    end

    it "should output this text" do
      # TODO: we need to test that the text output is actually right. I'm putting this off until next week though.
      # # IO.expects(:write).with("features/support/appium.txt", expected).once
      # expect(IO).to recieve(:write).with("features/support/appium.txt", expected)

      # @appiumtext.execute
      # # expect(@appiumtext.appium_text_for_file).to match(expected)
      # # 
      # # 
      # # expect(logger).to receive(:account_closed).with(account)

      # # account.close
    end

  end
end
