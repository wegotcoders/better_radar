require 'spec_helper'

RSpec.describe BetterRadar::Parser do

  describe "parse method" do
    let(:mock_handler) do
      mock_handler = mock
      mock_handler.expects(:handle_tournament).once
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