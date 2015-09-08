require 'spec_helper'
RSpec.describe BetterRadar::Element::Base do

  let(:base) { BetterRadar::Element::Base.new }
  describe 'empty?' do
    it 'should return false if at least one instance variable is not empty' do
      base.instance_variable_set('@assigned_string', 'to something')
      base.instance_variable_set('@emtpy_string', '')
      expect(base.empty?).to eq false
    end

    it 'should return true if all instance variables are nil or empty' do
      base.instance_variable_set('@nil_string', nil)
      base.instance_variable_set('@emtpy_string', '')
      expect(base.empty?).to eq true
    end

    it 'should return false if nested elements are not empty' do
      element = BetterRadar::Element::Base.new
      element.instance_variable_set('@assigned_array', [:assigned, :array])
      base.instance_variable_set("@assigned_element", element)
      expect(base.empty?).to eq false
    end

    it 'should return true if nested elements are empty' do
      element = BetterRadar::Element::Base.new
      element.instance_variable_set('@empty_array', [])
      base.instance_variable_set("@assigned_element", element)
      expect(base.empty?).to eq true
    end
  end
end
