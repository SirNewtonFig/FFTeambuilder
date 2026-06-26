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
      c = Skill::ComputeFormula.perform(character:, skill:, expression:)

      next unless c.success?

      parsed_formula.gsub!(expression[:expression], [expression[:expression], "[#{c.result}]"].join(''))
      parsed_formula.gsub!(/(\[#{c.result}\])+/, "[#{c.result}]")
    end

    context.result = parsed_formula
  end
end
