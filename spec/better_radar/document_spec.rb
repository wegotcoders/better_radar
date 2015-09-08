require 'spec_helper'

RSpec.describe BetterRadar::Document do
  let(:handler) { double("Handler") }
  let(:document) { BetterRadar::Document.new(handler) }

  let!(:sport) do
    sport = BetterRadar::Element::Sport.new
    sport.betradar_sport_id = "3"
    document.instance_variable_set("@sport", sport)
    sport
  end

  let!(:category) do
    category = BetterRadar::Element::Category.new
    category.betradar_category_id = "16"
    document.instance_variable_set("@category", category)
    category
  end

  let!(:tournament) do
    tournament = BetterRadar::Element::Tournament.new
    tournament.betradar_tournament_id = "25"
    document.instance_variable_set("@tournament", tournament)
    tournament
  end

  let!(:match) do
    match = BetterRadar::Element::Match.new
    match.betradar_match_id = "3"
    document.instance_variable_set("@match", match)
    match
  end

  let!(:levels) { document.hierarchy_levels = ["Sport", "Category", "Tournament", "Match"] }

  describe '#assign_parent_data' do


    describe 'providing the ids of it\'s parent elements' do

      it "should assign parents for match" do
        document.send(:assign_parent_data, match)
        expect(match.betradar_sport_id).to eq '3'
        expect(match.betradar_category_id).to eq '16'
        expect(match.betradar_tournament_id).to eq '25'
      end
    end
  end
end
