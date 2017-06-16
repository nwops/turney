#!/usr/bin/env ruby
require 'turney'


number_of_teams = ARGV.first.to_i
Turney.start(number_of_teams)