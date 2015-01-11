# coding: utf-8

module Cuesmash

  #
  # iOS Specific compiler
  #
  class IosCompiler < Compiler

    attr_accessor :scheme
    attr_accessor :tmp_dir
    attr_accessor :build_configuration

    def initialize(scheme:, tmp_dir:, build_configuration:)
      @scheme = scheme
      @tmp_dir = tmp_dir
      @build_configuration = build_configuration
    end

    #
    # Generate the string to be used as the xcode build command
    # using the scheme ivar
    #
    # @return [String] The full xcode build command with args
    def command
      xcode_command = "set -o pipefail && xcodebuild #{workspace} -scheme #{@scheme} -derivedDataPath #{@tmp_dir} -configuration #{@build_configuration} OBJROOT=#{@tmp_dir} SYMROOT=#{@tmp_dir} -sdk iphonesimulator build | bundle exec xcpretty -c"

      Logger.info "xcode_command == #{xcode_command}"
      xcode_command
    end # command

    #
    # Looks in the current directory for the workspace file and
    # gets its name if there is one
    #
    # @return [String] The name of the workspace file that was found along with the -workspace flag
    def workspace
      wp = Dir["*.xcworkspace"].first
      if wp
        flag = "-workspace #{wp}"
        Logger.debug "workspace == #{wp}"
        return flag
      else
        Logger.debug "no workspace found"
        return wp
      end
    end # workspace
  end # class IosCompiler
end # module Cuesmash
