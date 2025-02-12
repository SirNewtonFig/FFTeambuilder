module FormulaHelper
  def eval_skill_formula(character:, skill:)
    Skill::EvaluateFormula.perform(character:, skill:).result.to_s
  rescue => e
    Rails.logger.debug(e)
    Rails.logger.debug(e.backtrace)
    skill.formula
  end

  def eval_weapon_formula(character:, weapon:)
    Weapon::EvaluateFormula.perform(character:, weapon:).result.to_s
  rescue => e
    Rails.logger.debug(e)
    Rails.logger.debug(e.backtrace)
    weapon.formula
  end
end
  