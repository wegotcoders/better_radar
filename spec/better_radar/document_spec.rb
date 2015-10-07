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

  let(:outright) do
    outright = BetterRadar::Element::Outright.new
    outright.betradar_outright_id = "8"
    document.instance_variable_set("@outright", outright)
    outright
  end

  describe '#assign_parent_data' do


    describe 'providing the ids of it\'s parent elements' do

      it "should assign parents for match" do
        document.instance_variable_set("@hierarchy_levels", ["Sport", "Category", "Tournament", "Match"])
        document.send(:assign_parent_data, match)
        expect(match.betradar_sport_id).to eq '3'
        expect(match.betradar_category_id).to eq '16'
        expect(match.betradar_tournament_id).to eq '25'
      end

      it "should assign parents for outright" do
        document.instance_variable_set("@hierarchy_levels", ["Sport", "Category", "Outright"])
        document.send(:assign_parent_data, outright)
        expect(outright.betradar_sport_id).to eq '3'
        expect(outright.betradar_category_id).to eq '16'
      end

      it "should assign parents for tournament" do
        document.instance_variable_set("@hierarchy_levels", ["Sport", "Category", "Tournament"])
        document.send(:assign_parent_data, tournament)
        expect(tournament.betradar_sport_id).to eq '3'
        expect(tournament.betradar_category_id).to eq '16'
        expect(tournament.betradar_tournament_id).to eq '25'
      end

      it "should assign parents for category" do
        document.instance_variable_set("@hierarchy_levels", ["Sport", "Category"])
        document.send(:assign_parent_data, category)
        expect(category.betradar_sport_id).to eq '3'
        expect(category.betradar_category_id).to eq '16'
      end

      it "should pass for sport" do
        document.instance_variable_set("@hierarchy_levels", ["Sport"])
        expect { document.send(:assign_parent_data, sport) }.to_not change sport, :betradar_sport_id
      end
    end
  end
end
