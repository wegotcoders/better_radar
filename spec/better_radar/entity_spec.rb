require 'spec_helper'

RSpec.describe BetterRadar::Element::Entity do

  describe "#assigned_variables" do
    let(:entity) { BetterRadar::Element::Entity.new }
    let(:output) { { :@test => "value" } }

    before do
      entity.instance_variable_set("@test", "value")
    end

    it "should return back all the variables which have been set" do
      expect(entity.assigned_variables).to eq output
    end

  end
end
