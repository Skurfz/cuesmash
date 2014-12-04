#!/usr/bin/env ruby
# coding: utf-8

require 'fileutils'
require 'uri'
require 'rest_client'
require 'json'
require 'open-uri'

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
        create_scripts_dir
        create_build_sh
        create_gemfile
      end

      # TODO: the git checkouts needs to check to see if the dirs have already been
      # checked out.

      private

      #
      # Honestly all of these should be self evident as to what they do. If you still can't figure it ou
      # come find me and I'll beat you with a ruby hammer.
      #
      def install_cucumber
        command_runner(command: "gem install --no-rdoc --no-ri cucumber")
      end

      # TODO: check if these exist already
      def create_features_dir
        command_runner(command: "mkdir -p features/{support,step_definitions}")
      end

      # TODO: check if this file exists already. If so ask if you want to overwrite it.
      def create_env_rb
        download_gist(gist_id:"9fa5e495758463ee5340", final_file:"features/support/env.rb")
      end

      # TODO: this is failing.
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
        download_gist(gist_id:"74cc418331bd81651746", final_file:".travis.yml")
      end

      def create_scripts_dir
        puts "creating scripts dir"
        command_runner(command: "mkdir -p scripts")
      end

      def create_build_sh
        download_gist(gist_id:"8df9762a103c694f5773", final_file:"scripts/build.sh")
      end

      def create_gemfile
        download_gist(gist_id:"ea786f1cf0fdbe0febb3", final_file:"Gemfile")
      end

      #
      # Run the command line
      #
      # @param command [String] The command line statement to run
      #
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

      #
      # Download gists files without git.
      # @param gist_id: [String] the gist id
      # @param final_file: [String] where the final file gets saved
      #
      def download_gist(gist_id:, final_file:)
        base_url = URI("https://api.github.com/gists/")
        json = JSON.parse(RestClient.get(URI.join(base_url, gist_id).to_s))
        file_name = json['files'].keys[0]
        raw_url = json['files'][file_name]['raw_url']

        open(final_file, 'wb') do |file|
          file << open(raw_url).read
        end
      end # download_gist
    end # class << self
  end # Class Setup
end # Module Cuesmash
