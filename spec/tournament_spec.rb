require "spec_helper"

RSpec.describe Tournament do

  let(:team_count) { 5 }

  let(:teams) do
    Tournament.seed_teams(team_count)
  end

  describe 'odd number of teams' do
    let(:team_count) { 5 }

    it "picks a winner" do
      winner, brackets = Tournament.play(teams)
      expect(winner).to be_a(Team)
    end

    it 'contains multiple brackets' do
      winner, brackets = Tournament.play(teams)
      expect(brackets.count).to be > 1
    end

    it 'has enough games' do
      winner, brackets = Tournament.play(teams)
      brackets.each do |bracket|
        game_count = (bracket.teams.count / 2) + (bracket.teams.count % 2)
        expect(bracket.games.count).to eq(game_count)
      end
    end

    it "has a bye team" do
      winner, brackets = Tournament.play(teams)
      team = brackets.first.teams.find {|g| g.bye?}
      expect(team).to be_a(Team)
      expect(team.bye?).to be true
    end

    it "has a bye game" do
      winner, brackets = Tournament.play(teams)
      game = brackets.first.games.find {|g| g.bye_game?}
      expect(game).to be_a(Game)
      expect(game.bye_game?).to be true
    end
  end

  describe 'even number of teams' do

    let(:team_count) { 6 }


    it "picks a winner" do
      winner, brackets = Tournament.play(teams)
      expect(winner).to be_a(Team)
    end

    it 'contains multiple brackets' do
      winner, brackets = Tournament.play(teams)
      expect(brackets.count).to be > 1
    end

    it 'has enough games' do
      winner, brackets = Tournament.play(teams)
      brackets.each do |bracket|
        game_count = (bracket.teams.count / 2) + (bracket.teams.count % 2)
        expect(bracket.games.count).to eq(game_count)
      end
    end

    it "does not have a bye team" do
      winner, brackets = Tournament.play(teams)
      team = brackets.first.teams.find {|g| g.bye?}
      expect(team).to eq(nil)
    end

    it "does not has a bye game" do
      winner, brackets = Tournament.play(teams)
      game = brackets.first.games.find {|g| g.bye_game?}
      expect(game).to eq nil
    end
  end

  describe 'serializes data' do

    it do
      winner, brackets = Tournament.play(teams)
      expect(brackets.first.to_json).to be_a(String)
    end
  end

end
