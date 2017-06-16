require "spec_helper"

RSpec.describe Tournament do


  let(:teams) do
    Tournament.seed_teams(team_count)
  end
  [1,2,4,6,8,10,20,3,5,7,9,11,13,15,30, 100, 1000,10000].each do |num|
    let(:team_count) { num }
    describe "#{num} teams" do
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
  end

  describe 'serializes data' do
    let(:team_count) { 30 }

    it do
      winner, brackets = Tournament.play(teams)
      expect(brackets.first.to_json).to be_a(String)
    end
  end

end
