#!/usr/bin/env ruby
# coding: utf-8

require 'fileutils'

module Cuesmash
  class Setup
    class << self
      #
      # Run the command line programs to setup appium. Based on steps from http://appium.io/slate/en/tutorial/ios.html?ruby#install-ruby
      #
      def setup
        install_cucumber
        create_features_dir
        create_env_rb
        install_appium_console
        install_brew
        install_node
        create_travis_yml
      end

      private

      #
      # Honestly all of these should be self evident as to what they do
      #
      
      def install_cucumber
        command_runner(command: "gem install --no-rdoc --no-ri cucumber")
      end

      def create_features_dir
        command_runner(command: "mkdir -p features/{support,step_definitions}")
      end

      def create_env_rb
        command_runner(command: "git clone https://gist.github.com/9fa5e495758463ee5340.git features/support/")
      end

      def install_appium_console
        command_runner(command: "gem install --no-rdoc --no-ri appium_console")
      end

      def install_brew
        brew_path = `which brew`
        if brew_path == 0
          command_runner(command: "ruby -e \"$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)\"")
        else
          Logger.info "Brew already installed."
        end
      end

      def install_node
        command_runner(command: "brew update; brew upgrade node; brew install node")
      end

      def create_travis_yml
        command_runner(command: "git clone https://gist.github.com/74cc418331bd81651746.git travis")
        FileUtils.mv('travis/.travis.yml', './.travis.yml')
        FileUtils.rm_r('travis/')
      end

      #
      # Run the command line
      # @param command: [String] The command line statement to run
      def command_runner(command:)
        status = nil
        Logger.info "Starting: #{command}"
        Open3.popen3 command do |stdin, out, err, wait_thr|
          [out, err].each do |stream|
            Thread.new do
              until (line = stream.gets).nil? do
                Logger.info line
              end # until
            end # Thread.new
          end # each
          wait_thr.join
          status = wait_thr.value.exitstatus
        end # Open3

        if status != 0
          Logger.info "Command failed: #{command}"
          exit status
        else
          Logger.info "Finished: #{command}"
        end
        return
      end # command_runner
    end # class << self
  end # Class Setup
end # Module Cuesmash
