class Skill::ParseFormulaContext < ActiveInteractor::Context::Base
  extend Memoist
  
  attribute :skill
  attribute :parts
end
  
class Skill::ParseFormula < ActiveInteractor::Base
  FORMULA_PATTERN = /((?:Hit|Dmg|Heal|Absorb\w+)_(?:U|F|P|MP)?)(\((?>[^)(]+|\g<2>)*\))/i

  delegate :skill, to: :context
  delegate :formula, to: :skill

  def perform
    context.parts = formula.scan(FORMULA_PATTERN).map{|(function, expression)| { function:, expression: }}
  end
end
  