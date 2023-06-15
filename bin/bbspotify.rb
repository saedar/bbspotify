#!/usr/bin/env ruby

require_relative '../lib/bbspotify.rb'

bbspotify = BBSpotify.new(File.read(ARGV[0]), File.read(ARGV[1]))

bbspotify.process