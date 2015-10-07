require 'spec_helper'

RSpec.describe BetterRadar::Configuration do

  let(:config) { BetterRadar::Configuration.new }

  describe "default values" do

    it "should provide default values if some haven't been set" do
      expect(config.feed_name).to eq "Fixtures"
      expect(config.delete_after_transfer).to eq false
    end

  end

  describe "custom values" do

    before do
      config.feed_name = "Other Feed"
      config.username = "Stannis_Baratheon"
      config.key = "Stann15TheMann15"
      config.delete_after_transfer = true
    end

    it "should allow for the feed name to be changed" do
      expect(config.feed_name).to eq "Other Feed"
      expect(config.username).to eq "Stannis_Baratheon"
      expect(config.key).to eq "Stann15TheMann15"
      expect(config.delete_after_transfer).to eq true
    end
  end

end
