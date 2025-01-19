module FormulaHelper
  def eval_formula(character:, skill:)
    Skill::EvaluateFormula.perform(character:, skill:).result.to_s
  rescue => e
    Rails.logger.debug(e)
    Rails.logger.debug(e.backtrace)
    skill.formula
  end
end
  