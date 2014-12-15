# coding: utf-8

module Cuesmash

  #
  # iOS Specific compiler
  # 
  class AndroidCompiler < Compiler

    OUTPUT_PATH = "app/build/outputs/apk"

    attr_accessor :tmp_dir

    def initialize(tmp_dir:)
      @tmp_dir = tmp_dir
    end

    #
    # Generate the string to be used as the gradle build command
    # using the scheme ivar
    #
    # @return [String] The full gradle build command with args
    def command
      gradle_command = './gradlew assemble'

      Logger.info "gradle_command == #{gradle_command}"
      gradle_command
    end # command
  end # class AndroidCompiler
end # module Cuesmash