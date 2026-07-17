class Weapon::EvaluateFormulaContext < ActiveInteractor::Context::Base
  extend Memoist

  attribute :character
  attribute :weapon
  attribute :result
  attribute :damage
  attribute :wp_modifier, default: 0
  attribute :resolve_two_fist, default: true
end

class Weapon::EvaluateFormula < ActiveInteractor::Base
  delegate :character, :weapon, :wp_modifier, :resolve_two_fist, to: :context

  def perform
    expression = Weapon::ParseFormula.perform(weapon:).expression

    parsed_formula = weapon.formula.dup

    c = Weapon::ComputeFormula.perform(character:, weapon:, expression:, wp_modifier:)

    return unless c.success?

    damage = c.result
    damage *= 2 if resolve_two_fist && weapon.name == 'Unarmed Strike' && character.two_fists?

    parsed_formula.gsub!(expression, [expression, "[#{damage}]"].join(' '))

    context.result = parsed_formula
    context.damage = damage
  end
end
