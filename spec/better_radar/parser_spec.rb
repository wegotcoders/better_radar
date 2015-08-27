require 'spec_helper'

RSpec.describe BetterRadar::Parser do

  describe "parse method" do

    let(:handler) { double }

    describe "parsing a sport" do

      let(:xml) { File.read('spec/fixtures/sample_sport.xml') }

      before do
        allow(handler).to receive(:handle_sport).once do |sport|

          expect(sport.class).to eq BetterRadar::Element::Sport
          expect(sport.betradar_sport_id).to eq "1"
          expect(sport.names.count).to eq 2
          expect(sport.names.first).to eq({ language: "BET", name: "Soccer" })
          expect(sport.names.last).to eq({ language: "en", name: "Soccer" })
        end
      end

      it "should handle handle the sport and return back the data" do
        BetterRadar::Parser.parse(xml, handler)
      end
    end

    describe "parsing a category" do
      let(:xml) { File.read('spec/fixtures/sample_category.xml') }

      before do
        allow(handler).to receive(:handle_category).once do |category|
          expect(category.class).to eq BetterRadar::Element::Category
          expect(category.betradar_category_id).to eq "1"
          expect(category.names.count).to eq 2
          expect(category.names.first).to eq({ language: "BET", name: "England" })
          expect(category.names.last).to eq({ language: "en", name: "England" })
        end
      end

      it "should handle handle the category and return back the data" do
        BetterRadar::Parser.parse(xml, handler)
      end
    end

    describe "parsing a tournament" do

      let(:xml) { File.read('spec/fixtures/sample_tournament.xml') }

      before do
        allow(handler).to receive(:handle_tournament).once do |tournament|
          expect(tournament.class).to eq BetterRadar::Element::Tournament
          expect(tournament.betradar_tournament_id).to eq "2"
          expect(tournament.names.count).to eq 2
          expect(tournament.names.first).to eq({ language: "BET", name: "Championship" })
          expect(tournament.names.last).to eq({ language: "en", name: "Championship" })
        end
      end

      it "should handle handle the sport and return back the data" do
        BetterRadar::Parser.parse(xml, handler)
      end
    end


    describe "parsing a match" do

      let(:xml) { File.read('spec/fixtures/sample_match.xml') }

      before do
        allow(handler).to receive(:handle_match).once do |match|
          expect(match.class).to eq BetterRadar::Element::Match
          expect(match.betradar_match_id).to eq "109379"

          expect(match.competitors.count).to eq 2
          expect(match.competitors.first[:id]).to eq "9373"
          expect(match.competitors.first[:superid]).to eq "9243"
          expect(match.competitors.first[:type]).to eq "1"
          expect(match.competitors.first[:name]).to eq "1. FC BRNO"

          expect(match.competitors.last[:id]).to eq "371400"
          expect(match.competitors.last[:superid]).to eq "1452"
          expect(match.competitors.last[:type]).to eq "2"
          expect(match.competitors.last[:name]).to eq "FC SLOVACKO"

          expect(match.date).to eq "2004 − 8 − 23T16:40:00"

          expect(match.bets.count).to eq 1
          expect(match.bets.first.class).to eq BetterRadar::Element::Bet
          expect(match.bets.first.type).to eq "10"

          expect(match.bets.first.odds.count).to eq 3
          expect(match.bets.first.odds.first.class).to eq BetterRadar::Element::Odds

          expect(match.bets.first.odds[0].outcome).to eq "1"
          expect(match.bets.first.odds[0].value).to eq "2,15"

          expect(match.bets.first.odds[1].outcome).to eq "X"
          expect(match.bets.first.odds[1].value).to eq "2,85"

          expect(match.bets.first.odds[2].outcome).to eq "2"
          expect(match.bets.first.odds[2].value).to eq "2,9"

          expect(match.scores.count).to eq 2
          expect(match.scores.first).to eq({ type: "FT", value: "1:0" })
          expect(match.scores.last).to eq({ type: "HT", value: "0:0" })

          expect(match.result_comment).to eq "1:0(62.)Luis Fabiano"

          expect(match.goals.count).to eq 1
          goal = match.goals.first
          expect(goal.id). to eq "4199894"
          expect(goal.scoring_team). to eq "1"
          expect(goal.team1). to eq "1"
          expect(goal.team2). to eq "0"
          expect(goal.time). to eq "62:00"

          expect(goal.player.class). to eq BetterRadar::Element::Player
          expect(goal.player.id).to eq "17149"
          expect(goal.player.name).to eq "Luís Fabiano"

          expect(match.cards.count).to eq 2
          expect(match.cards.first.id).to eq "4199983"
          expect(match.cards.first.time).to eq "42:00"
          expect(match.cards.first.type).to eq "Yellow"

          expect(match.cards.first.player.class).to eq BetterRadar::Element::Player
          expect(match.cards.first.player.id).to eq "39586"
          expect(match.cards.first.player.name).to eq "Petrovi, Radosav"

          expect(match.cards.last.id).to eq "4200011"
          expect(match.cards.last.time).to eq "45:00"
          expect(match.cards.last.type).to eq "Yellow"

          expect(match.cards.last.player.class).to eq BetterRadar::Element::Player
          expect(match.cards.last.player.id).to eq "39584"
          expect(match.cards.last.player.name).to eq "Lazic, Djordje"

          expect(match.bet_results.count).to eq 27
          expect(match.bet_results.first.class).to eq BetterRadar::Element::BetResult

          expect(match.bet_results.first.type).to eq "01"
          expect(match.bet_results.first.outcome).to eq "X"
          expect(match.bet_results.first.special_value).to eq "0:1"


          expect(match.bet_results[10].type).to eq "46"
          expect(match.bet_results[10].outcome).to eq "12"
          expect(match.bet_results[10].special_value).to eq nil

          expect(match.bet_results.last.type).to eq "54"
          expect(match.bet_results.last.outcome).to eq "Over"
          expect(match.bet_results.last.special_value).to eq "1,25"

          expect(match.probabilities.count).to eq 3
          expect(match.probabilities.first.class).to eq BetterRadar::Element::BetProbability

          expect(match.probabilities.first.type).to eq "01"
          expect(match.probabilities.first.outcome_probabilities.count).to eq 3
          expect(match.probabilities.first.outcome_probabilities.first).to eq({ outcome: "1", special_value: "1:0", value: "0,609" })

          expect(match.probabilities.last.type).to eq "60"
          expect(match.probabilities.last.outcome_probabilities.count).to eq 2
          expect(match.probabilities.last.outcome_probabilities.last).to eq({ outcome: "Under", special_value: "2,5", value: "0,4775" })
        end
      end

      it "should handle handle the match and return back the data" do
        BetterRadar::Parser.parse(xml, handler)
      end
    end

    describe "parsing an outright" do

      let(:xml) { File.read('spec/fixtures/sample_outright.xml') }

      before do
        allow(handler).to receive(:handle_outright).once do |category|
          expect(outright.betradar_outright_id).to eq "2332"
        end
      end

      it "should handle handle the outright and return back the data" do
        BetterRadar::Parser.parse(xml, handler)
      end
    end

  end
end
