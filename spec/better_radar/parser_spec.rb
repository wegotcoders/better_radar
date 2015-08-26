require 'spec_helper'

RSpec.describe BetterRadar::Parser do

  describe "parse method" do

    let(:mock_handler) { mock }

    let(:sport_data) do
      {
      :betradarsportid => '1',
      names:
        [
          {language: "BET", name: "Soccer"},
          {language: "en", name: "Soccer",}
        ]
      }
    end

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
        betradarmatchid: '109379'
      }

    end

    let(:outright_data) do
      {
        betradaroutrightid: '2332',
        fixture: {
          event_info:
            {
              event_date: '2012−5−30T21:00:00',
              event_name: 'France Ligue 1 2011/12 − Outright Winner',
              off: '0',
              tournamentid: '17'
            },
          competitors:
          [
            {
              id: '4891',
              superid: '1645',
              name: 'Girondins Bordeaux'
            },
            {
              id: '5380',
              superid: '1641',
              name: 'Olympique Marseille'
            }
          ]
        },
        aamsoutrightid: '10697.120',
        outrightodds: {
          #oddstype: 'C',
          odds_collection: [
            {id: '4891', value: '1,12'},
            {id: '5380', value: '6,5'}
          ]
        }
      }
    end

    describe "parsing a sport" do
      before do
        @xml = File.read('spec/fixtures/sample_sport.xml')
        mock_handler.expects(:handle_sport).with(sport_data).once
      end

      it "should handle handle the sport and return back the data" do
        BetterRadar::Parser.parse(@xml, mock_handler)
      end
    end

    describe "parsing a tournament" do
      before do
        @xml = File.read('spec/fixtures/sample_tournament.xml')
        mock_handler.expects(:handle_tournament).with(tournament_data).once
      end

      it "should handle handle the sport and return back the data" do
        BetterRadar::Parser.parse(@xml, mock_handler)
      end
    end

    describe "parsing an outright" do
      before do
        @xml = File.read('spec/fixtures/sample_outright.xml')
        mock_handler.expects(:handle_outright).with(outright_data).once
      end

      it "should handle handle the outright and return back the data" do
        BetterRadar::Parser.parse(@xml, mock_handler)
      end
    end

    describe "parsing a category" do
      before do
        @xml = File.read('spec/fixtures/sample_category.xml')
        mock_handler.expects(:handle_category
          ).with(category_data).once
      end

      it "should handle handle the sport and return back the data" do
        BetterRadar::Parser.parse(@xml, mock_handler)
      end
    end

    describe "parsing a match" do

      before do
        @xml = File.read('spec/fixtures/sample_match.xml')
        mock_handler.expects(:handle_match).with(match_data).once
      end

      it "should notify the handler to handle a match" do
        BetterRadar::Parser.parse(@xml, mock_handler)
      end
    end

    describe "parsing a feed" do
      before do
        @xml = File.read('spec/fixtures/example_feed.xml')
        mock_handler.expects(:handle_sport).with(sport_data).once
        mock_handler.expects(:handle_category).with(category_data).once
        mock_handler.expects(:handle_tournament).with(tournament_data).once
        # mock_handler.expects(:handle_match_data).with(match_data).once
      end

      it "should handle handle the sport and return back the data" do
        BetterRadar::Parser.parse(@xml, mock_handler)
      end
    end
  end
end
