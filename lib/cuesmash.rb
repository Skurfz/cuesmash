#!/usr/bin/env ruby
# coding: utf-8

require 'optparse'
require 'open3'
require 'find'
require 'socket'
require 'fileutils'
require 'tmpdir'
require 'logger'
require 'yaml'

require 'cuesmash/command'
require 'cuesmash/compiler'
require 'cuesmash/cucumber'
require 'cuesmash/appium_text'
require 'cuesmash/ios_app'
require 'cuesmash/appium_server'
require 'cuesmash/jsonconf'

module Cuesmash
  PORT = 4567

  Logger = Logger.new(STDOUT)
  Logger.level = ::Logger::INFO
  Logger.formatter = proc do |serverity, time, progname, msg|
    "\n#{msg.rstrip}"
  end
end
