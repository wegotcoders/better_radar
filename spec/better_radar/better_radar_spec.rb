require 'spec_helper'

RSpec.describe BetterRadar do

  describe ".configure" do
    before do
      BetterRadar.configure do |config|
        config.feed_name = "Fixtures"
        config.username = "Robert_Baratheon"
        config.key = "123456"
        config.delete_after_transfer = false
      end
    end

    it "should set the configurable options" do
      expect(BetterRadar.configuration.username).to eq "Robert_Baratheon"
    end
  end
end
