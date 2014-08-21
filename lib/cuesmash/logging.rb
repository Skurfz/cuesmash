#!/usr/bin/env ruby
# coding: utf-8

module Logging
  def logger
    Logging.logger
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
end
