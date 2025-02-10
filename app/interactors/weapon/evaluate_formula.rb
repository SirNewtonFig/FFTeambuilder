class Weapon::EvaluateFormulaContext < ActiveInteractor::Context::Base
  extend Memoist

  attribute :character
  attribute :weapon
  attribute :result
end
  
class Weapon::EvaluateFormula < ActiveInteractor::Base
  delegate :character, :weapon, to: :context

  def perform
    expression = Weapon::ParseFormula.perform(weapon:).expression

    parsed_formula = weapon.formula.dup

    c = Weapon::ComputeFormula.perform(character:, weapon:, expression:)

    return unless c.success?

    context.result = c.result
  end
end
  