require 'turney/game'
require 'turney/team'

# A Tournament is considered to represent a group of brackets where many winners are then
# sent to the next tournament until 1 team exists
class Tournament
  attr_accessor :games, :teams, :winners, :name

  def initialize(name, teams)
    @teams = teams
    @name = name
  end

  def number_of_games
    games.count
  end

  # recursively play until a winner is chosen
  def self.play(teams)
    t = Tournament.new('bracket0'.next,teams)
    winners = t.winners
    if winners.count > 1
      play(winners)
    else
      # return the winner
      winners.first
    end
  end

  # randomly select teams to play each other
  def games
    unless @games
      t_teams = teams.dup
      @games = t_teams.map { |_team| Game.new(t_teams.shuffle!.pop, t_teams.shuffle!.pop) }
    end
  end

  # @return [Array[Team]] - a array of the winning teams
  def winners
    @winners ||= games.map { |game| game.winner }
  end

  # given a number create teams based on that number
  # @return [Hash[Teams]]
  def self.seed_teams(number)
    teams = []
    teams << Team.new(:bye) unless number % 2 == 0
    (1..number).map { |index| Team.new("team#{index}") }
  end
end
