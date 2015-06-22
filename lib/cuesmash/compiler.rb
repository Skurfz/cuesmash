# coding: utf-8

module Cuesmash
  #
  # The calamsash compiler will compiles the Xcode project with the
  # scheme it's told to compile with.
  #
  class Compiler
    # Public: the Scheme the compiler is compiling
    attr_accessor :scheme
    attr_accessor :tmp_dir

    def initialize(scheme, tmp_dir)
      @scheme = scheme
      @tmp_dir = tmp_dir
    end

    #
    # The compiler's heart, executes the compiling with xcodebuild
    #
    # Returns nothing because it completes with a complete block
    def compile
      started
      status = nil

      Open3.popen3 command do |_stdin, out, err, wait_thr|
        print "\n"
        [out, err].each do |stream|
          Thread.new do
            until (line = stream.gets).nil?
              Logger.info line
            end
          end
        end
        wait_thr.join
        status = wait_thr.value.exitstatus
      end

      if status != 0
        # Logger.fatal "Compilation failed: #{output}"
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
      Logger.info 'Compiling'
    end

    #
    # Output a nice message for completing
    #
    def completed
      Logger.info 'Compiled 👌'
    end
  end # class compiler
end # module cuesmash
