
class Game
  attr_reader :team1, :team2
  def initialize(team1, team2)
    @team1 = team1
    @team2 = team2
  end

  def non_bye_team
    @non_bye_team ||= teams.find {|t| ! t.bye?}
  end

  def bye_game?
    team1.bye? or team2.bye?
  end

  def teams
    [team1, team2]
  end

  # @return [Team] - the winner of the game
  # randomly select a team to win
  def play
    puts "Playing #{team1.name} against #{team2.name}"
    winning_team = pick_winner
    puts "Team #{winning_team.name} won the game"
    winning_team
  end

  # @return [Team] - the winner of the game
  def winner
    @winner ||= play
  end

  private

  def pick_winner
    if bye_game?
      non_bye_team.played_bye = true
      non_bye_team
    else
      Random.new.rand(1..2) % 2 ? team1 : team2
    end
  end
end