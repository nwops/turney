
class Game
  attr_reader :team1, :team2, :name
  def initialize(name, team1, team2)
    raise ArgumentError if team1.nil? or team2.nil?
    @team1 = team1
    @team2 = team2
    @name = name
  end

  def non_bye_team
    @non_bye_team ||= teams.find {|t| t && !t.bye? }
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
    winning_team = pick_winner
    winning_team
  end

  # @return [Team] - the winner of the game
  def winner
    @winner ||= play
  end

  def to_json(pretty = false)
    {
        teams: teams,
        bye_game: bye_game?
    }.to_json(pretty)
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