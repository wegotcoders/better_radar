require 'spec_helper'

RSpec.describe BetterRadar::Parser do

  describe "parse method" do

    describe "parsing a full xml document" do
      let(:sport_data) do
        {
        :betradarsportid => '1',
        texts:
          [
            {language: "BET", name: "Soccer"},
            {language: "en", name: "Soccer",}
          ]
        }
      end

      let(:tournament_data) do
        {
          :betradartournamentid => '2',
          texts:
          [
            {:language => 'BET', :name => 'Championship'},
            {:language  => 'en', :name => 'Championship'}
          ]
        }
      end

      let(:category_data) do
        {
          :betradarcategoryid => '1',
          texts:
          [
            {:language => 'BET', :name => 'England'},
            {:language => 'en', :name => 'England'}
          ]
        }
      end

      let(:mock_handler) do
        mock_handler = mock
        mock_handler.expects(:handle_sport).with(sport_data).once
        mock_handler.expects(:handle_tournament).with(tournament_data).once
        mock_handler.expects(:handle_category).with(category_data).once
        mock_handler.expects(:handle_match).once
        mock_handler
      end

      before do
        @xml = File.read('spec/fixtures/example_feed.xml')
      end

      it "should handle the main hierarchical elements" do
        BetterRadar::Parser.parse(@xml, mock_handler)
      end
    end

    describe "parsing a match" do
      before do
        @xml = File.read('spec/fixtures/sample_match.xml')
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
            ]
          },
          match_odds: [],
          result: {},
          goals: [],
          cards: [],
          betradarmatchid: '109379'
        }
      end

      let(:mock_handler) do
        mock_handler = mock
        mock_handler.expects(:handle_match).with(match_data).once
        mock_handler
      end

      it "should notify the handler to handle a match" do
        BetterRadar::Parser.parse(@xml, mock_handler)
      end
    end
  end
end
