class Weapon::ParseFormulaContext < ActiveInteractor::Context::Base
  extend Memoist
  
  attribute :weapon
  attribute :expression
end
  
class Weapon::ParseFormula < ActiveInteractor::Base
  FORMULA_PATTERN = /(.+\s?\*\s?WP)/i

  delegate :weapon, to: :context
  delegate :formula, to: :weapon

  def perform
    matches = formula.match(FORMULA_PATTERN)

    context.expression = matches[1] if matches
  end
end
  