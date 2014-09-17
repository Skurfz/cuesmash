#!/usr/bin/env ruby
# coding: utf-8

module Cuesmash
  class Setup

    #
    # Run the command line programs to setup appium. Based on steps from http://appium.io/slate/en/tutorial/ios.html?ruby#install-ruby
    #
    def setup
      puts 'time to start making some dirs'
      install_cucumber
      create_features_dir
      create_env_rb
      install_appium_console
      install_brew
      install_node
    end

    private

    def install_cucumber
      command_line(command: "gem install cucumber")
    end

    def create_features_dir
      command_line(command: "mkdir -p features/{support,step_definitions}")
    end

    def create_env_rb
      command_line(command: "git clone https://gist.github.com/9fa5e495758463ee5340.git features/support/env.rb")
    end

    def install_appium_console
      command_line(command: "gem install --no-rdoc --no-ri appium_console")
    end

    def install_brew
      command_line(command: "ruby -e \"$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)\"")

    def install_node
      command_line(command: "brew update; brew upgrade node; brew install node")
    end

    #
    # Run the command line
    # @param command: [String] The command line statement to run
    def command_line(command:)
      status = nil
      Logger.info "Starting: #{command}"
      Open3.popen3 command do |stdin, out, err, wait_thr|
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
        Logger.info "Command failed: #{command}"
        exit status
      else
        Logger.info "Finished: #{command}"
      end
      return
    end # command_line
  end # Class Setup
end
