class Skill::EvaluateProcrateContext < ActiveInteractor::Context::Base
  extend Memoist

  PROCRATE_PATTERN = /(\d+)%/

  attribute :character
  attribute :expression
  attribute :result

  memoize def brave
    return 70 if ['Lionheart', 'Lucky'].include?(character.support&.name)

    character.brave.to_i
  end

  memoize def scalar
    return 1.0 if brave == 50

    return 1.0 - 0.025 * (50 - brave) if brave < 50

    1.0 + 0.05 * (brave - 50)
  end

  memoize def procrate
    expression.match(PROCRATE_PATTERN)[1].to_i
  end
end

class Skill::EvaluateProcrate < ActiveInteractor::Base
  delegate :character, :result, :expression, :scalar, :procrate, to: :context

  def perform
    rate = calc("procrate * scalar", procrate:, scalar:).to_i

    parsed_formula = expression.dup

    parsed_formula.sub!(procrate.to_s, rate.to_s)

    context.result = parsed_formula
  end

  def calc(str, **options)
    Eqn::Calculator.calc("rounddown(#{str.downcase})", **options)
  end
end
