require 'spec_helper'

RSpec.describe BetterRadar::Parser do

  describe "parse method" do

    let(:handler) { double }

    let(:category_data) do
      {
        :betradarcategoryid => '1',
        names:
        [
          {:language => 'BET', :name => 'England'},
          {:language => 'en', :name => 'England'}
        ]
      }
    end

    let(:tournament_data) do
      {
        :betradartournamentid => '2',
        names:
        [
          {:language => 'BET', :name => 'Championship'},
          {:language  => 'en', :name => 'Championship'}
        ]
      }
    end

    let(:match_data) do
      {
        fixture:
          {
            competitors:
            [
              {
                id: "9373",
                superid: "9243",
                type: "1",
                name:'1. FC BRNO'
              },
              {
                id: "371400",
                superid: "1452",
                type: "2",
                name:'FC SLOVACKO'
              }
            ],
            date_info: { match_date: "2004 − 8 − 23T16:40:00" }
          },
        match_odds:
          [
            {
              odds:
              [
                { outcome: "1", value: "2,15" },
                { outcome: "X", value: "2,85" },
                { outcome: "2", value: "2,9" }
              ],

              oddstype: "10"
            }
          ],
        betradarmatchid: '109379',
        result:
          {
            score_info:
            [
              { score: "1:0", type: "FT" },
              { score: "0:0", type: "HT" }
            ],
            comment: "1:0(62.)Luis Fabiano"
          },
        goals:
          [
            id: "4199894", scoringteam: "1", team1: "1", team2: "0", time: "62:00", player:
              {
                id: "17149", name: "Luís Fabiano"
              }
          ],
        cards:
          [
            { id: "4199983", time: "42:00", type: "Yellow", player:
              {
                id: "39586", name: "Petrovi, Radosav"
              }
            },
            { id: "4200011", time: "45:00", type: "Yellow", player:
              {
                id: "39584", name: "Lazic, Djordje"
              }
            }
          ]

      }
    end

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

    describe "parsing a tournament" do

      let(:xml) { File.read('spec/fixtures/sample_tournament.xml') }

      before do
        allow(handler).to receive(:handle_sport).once do |tournament|
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

    # describe "parsing a category" do
    #   before do
    #     @xml = File.read('spec/fixtures/sample_category.xml')
    #     mock_handler.expects(:handle_category).with(category_data).once
    #   end

    #   it "should handle handle the sport and return back the data" do
    #     BetterRadar::Parser.parse(@xml, mock_handler)
    #   end
    # end

    # describe "parsing a match" do

    #   before do
    #     @xml = File.read('spec/fixtures/sample_match.xml')
    #     mock_handler.expects(:handle_match).with(match_data).once
    #   end

    #   it "should notify the handler to handle a match" do
    #     BetterRadar::Parser.parse(@xml, mock_handler)
    #   end
    # end

    # describe "parsing a feed" do
    #   before do
    #     @xml = File.read('spec/fixtures/example_feed.xml')
    #     mock_handler.expects(:handle_sport).with(sport_data).once
    #     mock_handler.expects(:handle_category).with(category_data).once
    #     mock_handler.expects(:handle_tournament).with(tournament_data).once
    #     # mock_handler.expects(:handle_match_data).with(match_data).once
    #   end

    #   it "should handle handle the sport and return back the data" do
    #     BetterRadar::Parser.parse(@xml, mock_handler)
    #   end
    # end
  end
end
