require 'spec_helper'

RSpec.describe BetterRadar::Element::CategoricalInformation do

  describe '#retrieve_name' do
    let(:categorical_entity) do
      entity = instance_double("Sport", names: [] )
      entity.extend(BetterRadar::Element::CategoricalInformation)
      entity
    end

    let!(:categorical_names) do
      categorical_entity.names << { language: 'BET', name: 'Foo' }
      categorical_entity.names << { language: 'en', name: 'Bar' }
    end

    it 'should return back the name in the default language if no argument is given' do
      expect(categorical_entity.retrieve_name).to eq 'Foo'
    end

    it 'should return back a name in a specific language' do
      expect(categorical_entity.retrieve_name('en')).to eq 'Bar'
    end
  end

end
