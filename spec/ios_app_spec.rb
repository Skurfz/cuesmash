require 'spec_helper'
require 'cuesmash/ios_app'
require 'cuesmash/app'

describe Cuesmash::IosApp do
  describe "when creating a new instance" do

    it "should have an app_dir instance" do
      stub_dir
      @iosapp = Cuesmash::IosApp.new(file_name: 'MyApp', build_configuration: 'Debug', app_name: '')
      expect(@iosapp.app_dir).to match('/tmp/Debug-iphonesimulator/')
    end

    it "should have an app_path instance" do
      stub_dir
      @iosapp = Cuesmash::IosApp.new(file_name: 'MyApp', build_configuration: 'Debug', app_name: '')
      expect(@iosapp.app_path).to match('/tmp/Debug-iphonesimulator/MyApp.app')
    end

    it "should have a tmp_dir instance" do
      stub_dir
      @iosapp = Cuesmash::IosApp.new(file_name: 'MyApp', build_configuration: 'Debug', app_name: '')
      expect(@iosapp.tmp_dir).to match('/tmp')
    end

    it "should have an app_name instance" do

      @iosapp = Cuesmash::IosApp.new(file_name: 'MyApp', build_configuration: 'Debug', app_name: '')
      expect(@iosapp.app_name).to match('MyApp.app')
    end

    def stub_dir
      Dir.stub(:mktmpdir) { '/tmp' }
    end
  end
end
