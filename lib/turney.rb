require "turney/version"
require 'turney/tournament'
require 'fileutils'

module Turney

  # @return [Team] - the winner of the tournament
  def self.start(number_of_teams)
    teams = Tournament.seed_teams(number_of_teams)
    Tournament.play(teams)
  end

  def self.draw(number_of_teams)
    teams = Tournament.seed_teams(number_of_teams)
    brackets_dir = File.join('tree', 'brackets')
    FileUtils.rm_rf(brackets_dir)
    winner, brackets = Tournament.play(teams)
    @bracket_dir = brackets_dir
    brackets.each do |bracket|
      @bracket_dir = File.join(@bracket_dir, bracket.name).gsub(' ', '_')
      FileUtils.mkdir_p(@bracket_dir)
      bracket.games.each do |game|
        game_dir = File.join(@bracket_dir, game.name).gsub(' ', '_')
        FileUtils.mkdir_p(File.join(game_dir, game.team1.name.to_s))
        FileUtils.mkdir_p(File.join(game_dir, game.team2.name.to_s))
        File.write(File.join(game_dir,game.winner.name, 'winner'), 'winner')
      end
    end
    brackets_dir
  end
end
