# coding: utf-8

module Cuesmash
  require 'shellwords'

  #
  # iOS Specific compiler
  #
  class IosCompiler < Compiler
    attr_accessor :scheme
    attr_accessor :tmp_dir
    attr_accessor :build_configuration

    def initialize(scheme:, tmp_dir:, build_configuration:, device: nil, device_name: nil)
      @scheme = scheme
      @tmp_dir = tmp_dir
      @build_configuration = build_configuration
      @device = device
      @device_name = device_name
    end

    #
    # Generate the string to be used as the xcode build command
    # using the scheme ivar
    #
    # @return [String] The full xcode build command with args
    def command
      xcode_command = 'set -o pipefail '
      xcode_command << "&& xcodebuild #{workspace} "
      xcode_command << "-scheme '#{@scheme}' "
      xcode_command << "-derivedDataPath #{@tmp_dir.shellescape} "
      xcode_command << "-configuration #{@build_configuration} "
      xcode_command << "OBJROOT=#{@tmp_dir.shellescape} "
      xcode_command << "SYMROOT=#{@tmp_dir.shellescape} "
      xcode_command << "-destination 'platform=iOS Simulator,name=#{@device_name}' " if @device.nil?
      xcode_command << 'build '
      xcode_command << '| bundle exec xcpretty -c'

      Logger.info "xcode_command == #{xcode_command}"
      xcode_command
    end # command

    #
    # Looks in the current directory for the workspace file and
    # gets its name if there is one
    #
    # @return [String] The name of the workspace file that was found along with the -workspace flag
    def workspace
      wp = Dir['*.xcworkspace'].first
      if wp
        flag = "-workspace #{wp}"
        Logger.debug "workspace == #{wp}"
        return flag
      else
        Logger.debug 'no workspace found'
        return wp
      end
    end # workspace
  end # class IosCompiler
end # module Cuesmash
