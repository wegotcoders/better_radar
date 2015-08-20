require 'spec_helper'

RSpec.describe BetterRadar::Parser do

  describe "parse method" do

    let(:sport_data) do
      {
      texts: %w(Soccer Soccer)
      }
    end

    let(:tournament_data) do
      {
        texts: %w(Championship Championship)
      }
    end

    let(:category_data) do
      {
        texts: %w(England England)
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

    it "should handle tournaments" do
      BetterRadar::Parser.parse(@xml, mock_handler)
    end
  end
end
