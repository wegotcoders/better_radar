require 'spec_helper'

RSpec.describe BetterRadar::Parser do

  describe "parse method" do

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
      @xml = File.read('spec/fixtures/example.xml')
    end

    it "should handle the main hierarchical elements" do
      BetterRadar::Parser.parse(@xml, mock_handler)
    end
  end
end
