RSpec.describe BetterRadar::Element::Match do

  let(:match) { BetterRadar::Element::Match.new }

  describe '#assign_attributes' do

    describe "assigning attributes from a Match node" do
      let(:attributes) { [["BetradarMatchID", "12345"]] }
      let(:current_element) { "BetRadarMatchID" }
      let(:context) { ["BetradarBetData", "Sports", "Sport", "Category", "Tournament", "Match"] }
      let!(:invocation) { match.assign_attributes(attributes, current_element, context) }

      it "should assign match specific details" do
        expect(match.betradar_match_id).to eq "12345"
      end
    end
  end

  describe '#assign_content' do
    describe "assigning the content to the appropriate variable" do
      let(:current_element) { "ID" }
      let(:content) { "123" }
      let(:context) { ["BetradarBetData", "Sports", "Sport", "Category", "Tournament", "Match", "Fixture", "RoundInfo", "ID"] }
      let!(:invocation) { match.assign_content(content, current_element, context) }

      it "should assign the round id" do
        expect(match.round.id).to eq "123"
      end
    end
  end
end
