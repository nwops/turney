require 'turney/game'
require 'turney/team'
require 'json'
# A Tournament is considered to represent a group of brackets where many winners are then
# sent to the next tournament until 1 team exists
class Tournament
  attr_accessor :games, :teams, :winners, :name

  def initialize(bracket_number, teams)
    @teams = teams
    @name = "Bracket #{bracket_number}"
  end

  def number_of_games
    games.count
  end

  def self.brackets
    @brackets ||= []
  end

  # recursively play until a winner is chosen
  def self.play(teams, brackets = [])
    teams << Team.new(:bye) if teams.count.odd?
    t = Tournament.new(brackets.count.next,teams)
    brackets.push(t)
    winners = t.winners
    if winners.count > 1
      play(winners, brackets)
    else
      # return the winner
      [winners.first, brackets]
    end
  end

  # randomly select teams to play each other
  def games
    unless @games
      t_teams = teams.dup
      game_count = (teams.count / 2) + (teams.count % 2)
      @games = game_count.times.map { |_team| Game.new(t_teams.shuffle!.pop, t_teams.shuffle!.pop) }
    end
    @games
  end

  # @return [Array[Team]] - a array of the winning teams
  def winners
    @winners ||= games.map { |game| game.winner }
  end

  # given a number create teams based on that number
  # @return [Hash[Teams]]
  def self.seed_teams(number)
    (1..number).map { |index| Team.new("team#{index}") }
  end

  def to_json(pretty = false)
    [
        name => {
            games: games,
            teams: teams,
            winners: winners
        }
    ].to_json(pretty)

  end
end
