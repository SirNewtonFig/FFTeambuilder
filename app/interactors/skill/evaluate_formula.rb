class Skill::EvaluateFormulaContext < ActiveInteractor::Context::Base
  extend Memoist

  attribute :character
  attribute :skill
  attribute :result
end
  
class Skill::EvaluateFormula < ActiveInteractor::Base
  delegate :character, :skill, to: :context

  def perform
    parts = Skill::ParseFormula.perform(skill:).parts

    parsed_formula = skill.formula.dup

    parts.each do |expression|
      Rails.logger.debug(expression.inspect)
      c = Skill::ComputeFormula.perform(character:, skill:, expression:)

      next unless c.success?

      Rails.logger.debug(c.result)

      parsed_formula.sub!(c.formula_expression, c.result)
    end

    context.result = parsed_formula
  end
end
  