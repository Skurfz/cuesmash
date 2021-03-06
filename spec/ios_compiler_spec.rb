require 'spec_helper'
require 'cuesmash/ios_compiler'

describe Cuesmash::IosCompiler do

  before(:each) do
    Cuesmash::IosCompiler.any_instance.stub(:puts)
  end

  it 'should have a scheme instance' do
    compiler = Cuesmash::IosCompiler.new(scheme: 'scheme', tmp_dir: '/tmp', build_configuration: 'Debug')
    expect(compiler.scheme).to match('scheme')
  end

  it 'should have a tmp_dir instance' do
    compiler = Cuesmash::IosCompiler.new(scheme: 'scheme', tmp_dir: '/tmp', build_configuration: 'Debug')
    expect(compiler.tmp_dir).to match('/tmp')
  end

  it 'should have a build config' do
    compiler = Cuesmash::IosCompiler.new(scheme: 'scheme', tmp_dir: '/tmp', build_configuration: 'Debug')
    expect(compiler.build_configuration).to match('Debug')
  end

  describe 'when generating the command' do

    before(:each) do
      Cuesmash::IosCompiler.any_instance.stub(:workspace)
      @compiler = Cuesmash::IosCompiler.new(scheme: 'test-scheme', tmp_dir: '/tmp', build_configuration: 'Debug')
    end

    it 'should contain the scheme' do
      expect(@compiler.instance_eval{command}).to match(/test-scheme/)
    end

    it 'should contain the tmp path' do
      expect(@compiler.instance_eval{command}).to match(/tmp/)
    end

    it 'should contain the build configuration' do
      expect(@compiler.instance_eval{command}).to match(/Debug/)
    end
  end

  describe 'when getting the workspacae' do

    before(:each) do
      @compiler = Cuesmash::IosCompiler.new(scheme: nil, tmp_dir: '/tmp', build_configuration: 'Debug')
      Dir.stub(:[]){['workspace-file']}
    end

    it 'should get the workspace from the current directory' do
      expect(@compiler.instance_eval{workspace}).to match(/workspace-file/)
    end
  end

  describe 'when compiling' do

    before(:each) do
      wait = double
      @value = double
      wait.stub(:value){@value}
      wait.stub(:join)
      Open3.stub(:popen3).and_yield(nil, nil, nil, wait)

      @compiler = Cuesmash::IosCompiler.new(scheme: nil, tmp_dir: '/tmp', build_configuration: 'Debug')
    end

    it 'should complete if all is well' do
      @value.stub(:exitstatus){0}
      @compiler.compile do |complete|
        expect(complete).to equal(true)
      end
    end
  end
end
