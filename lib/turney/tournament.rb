require 'turney/game'
require 'turney/team'
require 'json'
# A Tournament is considered to represent brackets where many winners are then
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

  # @param Array[[Team]]
  def self.add_bye(teams)
    # number of games/teams divided by 2 cannot be odd
    count = teams.count
    ans = divide(count)
    if ans.odd? or count.odd?
      return teams if count == 2
      teams << Team.new(:bye)
      add_bye(teams)
    else
      teams
    end
  end

  # recursively divides by 2 until we get less than 6
  # @return [Integer]
  def self.divide(num)
    ans = num / 2
    if ans > 5
      divide(ans)
    else
      ans
    end
  end

  # recursively play until a winner is chosen
  def self.play(teams, brackets = [])
    teams = add_bye(teams) if brackets.count == 0
    t = Tournament.new(brackets.count.next, teams)
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
      t_teams = teams.dup.shuffle!
      game_count = (teams.count / 2) + (teams.count % 2)
      @games = (1..game_count).map do |num|
        team1 = t_teams.shuffle!.pop
        if team1.bye?
          team2 = t_teams.find {|t| ! t.bye?}
          t_teams.delete(team2)
        else
          team2 = t_teams.find { |t| t.bye?} || t_teams.pop
          t_teams.delete(team2)
        end
        Game.new("Game#{num}",team1, team2)
      end
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
    {
        name => {
            games: games,
        }
    }.to_json(pretty)
  end
end
