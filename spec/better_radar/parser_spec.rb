require 'spec_helper'

RSpec.describe BetterRadar::Parser do

  describe "parse method" do
    let(:tournament_data) do
      {
        texts: %w(Championship Championship)
      }
    end

    let(:match_data) do
      {
        competitors: ["Burnley FC", "Brentford FC"]
      }
    end

    let(:mock_handler) do
      mock_handler = mock
      mock_handler.expects(:handle_tournament).with(tournament_data).once
      mock_handler.expects(:handle_match).with(match_data).once
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