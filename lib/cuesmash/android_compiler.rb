# coding: utf-8

module Cuesmash
  #
  # iOS Specific compiler
  #
  class AndroidCompiler < Compiler
    OUTPUT_PATH = 'app/build/outputs/apk'

    attr_accessor :project_name
    attr_accessor :build_configuration

    def initialize(project_name:, build_configuration:)
      @project_name = project_name
      @build_configuration = build_configuration
    end

    #
    # Generate the string to be used as the gradle build command
    # using the scheme ivar
    #
    # @return [String] The full gradle build command with args
    def command
      if !@build_configuration.nil?
        gradle_assemble_command = "./gradlew assemble#{@build_configuration.gsub('-', '')}"
      else
        fail '/nBuild configuration not found or invalid build configuration'
      end
      Logger.info "gradle_assemble_command == #{gradle_assemble_command}"
      gradle_assemble_command
    end # command
  end # class AndroidCompiler
end # module Cuesmash
