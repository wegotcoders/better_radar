module BetterRadar::Element

  class Base

    def empty?
      instance_variables.each do |var|
        return false unless instance_variable_get(var).nil? || instance_variable_get(var).empty?
      end
      true
    end
  end
end
