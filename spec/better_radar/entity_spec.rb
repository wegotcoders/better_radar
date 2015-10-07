
require 'spec_helper'

RSpec.describe BetterRadar::Element::Entity do

  let(:entity) { BetterRadar::Element::Entity.new }


  describe '#assigned_variables' do
    let(:output) { { :@test => 'value' } }

    before do
      entity.instance_variable_set('@test', 'value')
      entity.instance_variable_set('@empty_array', [])
    end

    it 'should return back all the variables which have been set' do
      expect(entity.assigned_variables).to eq output
    end
  end
end
