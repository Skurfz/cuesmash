#!/usr/bin/env ruby
# coding: utf-8

require 'optparse'
require "open3"
require 'cfpropertylist'
require 'find'
require 'socket'
require 'fileutils'
require 'tmpdir'

require 'cuesmash/command'
require 'cuesmash/compiler'
require 'cuesmash/plist'
require 'cuesmash/cucumber'

module Cuesmash
  PORT = 4567
end
