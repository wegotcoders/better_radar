require 'spec_helper'

RSpec.describe BetterRadar::Parser do

  describe "#parse" do

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

      it "should handle handle the tournament and return back the data" do
        BetterRadar::Parser.parse(xml, handler)
      end
    end

    describe "parsing a match" do

      let(:xml) { File.read('spec/fixtures/sample_match.xml') }

      before do
        allow(handler).to receive(:handle_match).once do |match|
          expect(match.class).to eq BetterRadar::Element::Match
          expect(match.betradar_match_id).to eq "109379"
          expect(match.off).to eq "0"
          expect(match.live_multi_cast).to eq "0"
          expect(match.live_score).to eq "0"
          expect(match.has_statistics).to eq "1"
          expect(match.neutral_ground).to eq "0"

          expect(match.betfair_ids.length).to eq 4

          expect(match.betfair_ids[:sport_id]).to eq "1"
          expect(match.betfair_ids[:event_id]).to eq "20436589"
          expect(match.betfair_ids[:runner1]).to eq "879210"
          expect(match.betfair_ids[:runner2]).to eq "2293061"

          expect(match.round).to_not be nil
          expect(match.round.class).to be BetterRadar::Element::Round
          expect(match.round.number).to eq "19"
          expect(match.round.id).to eq "7"
          expect(match.round.cup_round).to eq "Round 1"

          expect(match.competitors.count).to eq 2
          expect(match.competitors.first.class).to eq BetterRadar::Element::Competitor
          expect(match.competitors.first.context_id).to eq "9373"
          expect(match.competitors.first.betradar_super_id).to eq "9243"
          expect(match.competitors.first.type).to eq "1"
          expect(match.competitors.first.names.first[:name]).to eq "1. FC BRNO"

          expect(match.competitors.last.context_id).to eq "371400"
          expect(match.competitors.last.betradar_super_id).to eq "1452"
          expect(match.competitors.last.type).to eq "2"
          expect(match.competitors.last.names.first[:name]).to eq "FC SLOVACKO"

          expect(match.date).to eq "2004−8−23T16:40:00"

          expect(match.tv_info.class).to eq Hash
          expect(match.tv_info[:channel_id]). to eq "12731"
          expect(match.tv_info[:channel_name]). to eq "Eurosport − Astra 1C...Astra − 3407"
          expect(match.tv_info[:start_date]). to eq "2007 − 6 − 6T20:30:00"

          expect(match.bets.count).to eq 1
          expect(match.bets.first.class).to eq BetterRadar::Element::Bet
          expect(match.bets.first.type).to eq "10"

          expect(match.bets.first.odds.count).to eq 3
          expect(match.bets.first.odds.first.class).to eq BetterRadar::Element::Odds

          expect(match.bets.first.odds[0].outcome).to eq "1"
          expect(match.bets.first.odds[0].value).to eq "2,15"
          expect(match.bets.first.odds[0].outcome_id).to eq "1"
          expect(match.bets.first.odds[0].special_value).to eq "0:1"

          expect(match.bets.first.odds[1].outcome).to eq "X"
          expect(match.bets.first.odds[1].value).to eq "2,85"
          expect(match.bets.first.odds[1].outcome_id).to eq "2"
          expect(match.bets.first.odds[1].special_value).to eq "0:2"

          expect(match.bets.first.odds[2].outcome).to eq "2"
          expect(match.bets.first.odds[2].value).to eq "2,9"
          expect(match.bets.first.odds[2].outcome_id).to eq "3"
          expect(match.bets.first.odds[2].special_value).to eq "0:3"

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
          expect(match.bet_results.last.outcome_id). to eq "6"


          expect(match.bet_results.last.type).to eq "54"
          expect(match.bet_results.last.outcome).to eq "Over"
          expect(match.bet_results.last.special_value).to eq "1,25"

          expect(match.probabilities.count).to eq 3
          expect(match.probabilities.first.class).to eq BetterRadar::Element::BetProbability

          expect(match.probabilities.first.type).to eq "01"
          expect(match.probabilities.first.outcome_probabilities.count).to eq 3
          expect(match.probabilities.first.outcome_probabilities.first).to eq({ outcome: "1", special_value: "1:0", value: "0,609", outcome_id: "1" })

          expect(match.probabilities.last.type).to eq "60"
          expect(match.probabilities.last.outcome_probabilities.count).to eq 2
          expect(match.probabilities.last.outcome_probabilities.last).to eq({ outcome: "Under", special_value: "2,5", value: "0,4775", outcome_id: "300" })
        end
      end

      it "should handle handle the match and return back the data" do
        BetterRadar::Parser.parse(xml, handler)
      end
    end

    describe "parsing an outright" do

      let(:xml) { File.read('spec/fixtures/sample_outright.xml') }

      before do
        allow(handler).to receive(:handle_outright).once do |outright|
          expect(outright.betradar_outright_id).to eq "2332"
          expect(outright.off).to eq "0"
          expect(outright.event_date).to eq "2012−5−30T21:00:00"
          expect(outright.event_end_date).to eq "2016-05-07T14:00:00"
          expect(outright.event_names.first[:value]).to eq "France Ligue 1 2011/12 − Outright Winner"

          expect(outright.competitors.count).to eq 2

          expect(outright.competitors.first.names.first[:name]).to eq "Girondins Bordeaux"
          expect(outright.competitors.first.context_id).to eq "4891"
          expect(outright.competitors.first.betradar_super_id).to eq "1645"

          expect(outright.competitors.last.names.first[:name]).to eq "Olympique Marseille"
          expect(outright.competitors.last.context_id).to eq "5380"
          expect(outright.competitors.last.betradar_super_id).to eq "1641"

          expect(outright.aams_outright_ids.count).to eq 1
          expect(outright.aams_outright_ids.first).to eq "10697.120"

          expect(outright.bet.class).to eq BetterRadar::Element::Bet
          expect(outright.bet.odds.count).to eq 2

          expect(outright.bet.type).to eq "30"
          expect(outright.bet.odds.first.competitor_context_id).to eq "4891"
          expect(outright.bet.odds.first.value).to eq "1,12"
          expect(outright.bet.odds.last.competitor_context_id).to eq "5380"
          expect(outright.bet.odds.last.value).to eq "6,5"

          expect(outright.bet_results.first[:winning_team_id]).to eq "135998"
          expect(outright.bet_results.first[:position]).to eq "1"
          expect(outright.bet_results.last[:winning_team_id]).to eq "938682"
          expect(outright.bet_results.last[:position]).to eq "3"
        end
      end

      it "should handle handle the outright and return back the data" do
        BetterRadar::Parser.parse(xml, handler)
      end
    end

    describe "nested associations" do
      let(:xml) { File.read('spec/fixtures/example_feed2.xml') }

      before do
        # testing associations
        allow(handler).to receive(:handle_match).once do |match|
          expect(match.betradar_sport_id).to eq "3"
          expect(match.betradar_category_id).to eq "16"
          expect(match.betradar_tournament_id).to eq "25"
          expect(match.betradar_match_id).to eq "6926872"
        end

        allow(handler).to receive(:handle_outright).exactly(21).times
        allow(handler).to receive(:handle_tournament).once
        allow(handler).to receive(:handle_category).exactly(16).times
        allow(handler).to receive(:handle_sport).exactly(8).times do
        end
      end

      it "should find the correct number of components" do
        BetterRadar::Parser.parse(xml, handler)
      end
    end

    describe "parsing an example feed3" do
      let(:xml) { File.read('spec/fixtures/example_feed3.xml') }

      before do
        allow(handler).to receive(:handle_match)
        allow(handler).to receive(:handle_outright)
        allow(handler).to receive(:handle_tournament)
        allow(handler).to receive(:handle_category)
        allow(handler).to receive(:handle_sport)
      end

      it "should find the correct number of components" do
        BetterRadar::Parser.parse(xml, handler)
      end
    end
  end
end
