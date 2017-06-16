require "turney/version"
require 'turney/tournament'

module Turney

  # @return [Team] - the winner of the tournament
  def self.start(number_of_teams)
    teams = Tournament.seed_teams(number_of_teams)
    Tournament.play(teams)
  end


end
