require 'spec_helper'

describe Cuesmash::JsonConf do
  describe 'when executed' do
    before(:each) do
      @json = Cuesmash::JsonConf.new(app_path: 'spec', file_name: 'test', port: '4567')
      @json.stub(:update)
      @json.stub(:clear)
      @json.stub(:completed)
      @json.stub(:started)
    end

    it 'should update' do
      @json.should_receive(:update)
      @json.execute
    end
  end

  describe 'when updating' do
    before(:each) do
      @file_write = double(File)
      @file_write.stub(:write)

      @json = Cuesmash::JsonConf.new(app_path: 'spec', file_name: 'test', port: '4567')
      @json.stub(:clear)
      @json.stub(:completed)
      @json.stub(:started)
      @json.stub(:app_path) { 'app_path' }
      @json.stub(:file_name)
    end

    it 'should set the server ip and port' do
      @json.stub(:server_ip) { 'server_ip' }

      @json.execute
    end

    it 'should write the app server plist' do
      @json.execute
    end
  end
end
