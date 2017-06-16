require "turney/version"
require 'turney/tournament'

module Turney

  # @return [Team] - the winner of the tournament
  def self.start(number_of_teams)
    teams = Tournament.seed_teams(number_of_teams)
    winner, brackets = Tournament.play(teams)
    puts "#{winner.name.capitalize} won the tournament"
    [winner, brackets]
  end
end
