# coding: utf-8

module Cuesmash

  #
  # The calamsash compiler will compiles the Xcode project with the
  # scheme it's told to compile with.
  #
  # @author [alexfish]
  #
  class Compiler
    # include Logging

    # Public: the Scheme the compiler is compiling
    attr_accessor :scheme
    attr_accessor :tmp_dir
    attr_accessor :build_configuration

    def initialize(scheme, tmp_dir, build_configuration)
      @scheme = scheme
      @tmp_dir = tmp_dir
      @build_configuration = build_configuration
    end

    #
    # The compiler's heart, executes the compiling with xcodebuild
    #
    # Returns nothing because it completes with a complete block
    def compile
      started
      status = nil

      Open3.popen3 command do |stdin, out, err, wait_thr|
        print "\n"
        [out, err].each do |stream|
          Thread.new do
            until (line = stream.gets).nil? do
              Logger.info line
            end
          end
        end
        wait_thr.join
        status = wait_thr.value.exitstatus
      end

      if status != 0
        Logger.fatal "Compilation failed: #{output}"
        exit status
        status
      else
        completed
      end
    end

    private

    #
    # Output a nice message for starting
    #
    def started
      Logger.info "Compiling"
    end

    #
    # Output a nice message for completing
    #
    def completed
      Logger.info "Compiled 👌"
    end

    #
    # Generate the string to be used as the xcode build command
    # using the scheme ivar
    #
    # @return [String] The full xcode build command with args
    def command
      # xcode_command = "xcodebuild #{workspace} -scheme #{@scheme} -sdk iphonesimulator CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -derivedDataPath #{@tmp_dir}"
      xcode_command = "set -o pipefail && xcodebuild #{workspace} -scheme #{@scheme} -derivedDataPath #{@tmp_dir} -configuration #{@build_configuration} OBJROOT=#{@tmp_dir} SYMROOT=#{@tmp_dir} -sdk iphonesimulator build | bundle exec xcpretty -c"

      Logger.info "xcode_command == #{xcode_command}"
      xcode_command
    end

    #
    # Looks in the current directory for the workspace file and
    # gets it's name if there is one
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
    end
  end
end
