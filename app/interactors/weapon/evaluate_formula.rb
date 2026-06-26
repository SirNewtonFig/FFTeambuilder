class Weapon::EvaluateFormulaContext < ActiveInteractor::Context::Base
  extend Memoist

  attribute :character
  attribute :weapon
  attribute :result
  attribute :wp_modifier, default: 0
end

class Weapon::EvaluateFormula < ActiveInteractor::Base
  delegate :character, :weapon, :wp_modifier, to: :context

  def perform
    expression = Weapon::ParseFormula.perform(weapon:).expression

    parsed_formula = weapon.formula.dup

    c = Weapon::ComputeFormula.perform(character:, weapon:, expression:, wp_modifier:)

    return unless c.success?

    damage = c
    damage *= 2 if weapon.name == 'Unarmed Strike' && character.two_fists?

    parsed_formula.gsub!(expression, [expression, "[#{c.result}]"].join(' '))

    context.result = parsed_formula
  end
end
