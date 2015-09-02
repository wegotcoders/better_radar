require 'spec_helper'

RSpec.describe BetterRadar do

  describe "configurable values" do

    before do
      BetterRadar.configure do |config|
        config.feed_name = "Fixtures"
        config.username = "Robert_Baratheon"
        config.key = "123456"
        config.delete_after_transfer = true
      end
    end

    describe ".configure" do

      it "should set the configurable options" do
        expect(BetterRadar.configuration.username).to eq "Robert_Baratheon"
      end
    end

    describe ".reset" do

      before do
        BetterRadar.reset
      end

      it "should reset the values" do
        expect(BetterRadar.configuration.key).to eq nil
        expect(BetterRadar.configuration.delete_after_transfer).to eq false
      end

    end
  end

end
