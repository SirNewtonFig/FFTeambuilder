class Character::CalculateFormulaContext < ActiveInteractor::Context::Base
  extend Memoist

  FORMULA_PATTERN = /((?:Hit|Dmg|Heal|Absorb\w+)_(?:U|F|P|MP)?)(\((?>[^)(]+|\g<2>)*\))/i
  UNFAITH = '(100 - (faith-30) - 20)/100'
  FAITH = '(100 - (70-faith) - 20)/100'
  PALADIN = '(100 - (70-faith) - 20)/100'

  attribute :character
  attribute :skill
  attribute :result

  memoize def bindings
    stats = [:pa, :ma, :sp, :wp, :br, :faith, :weapons, :strengthens].index_with { |key| character.send(key) }

    stats[:faith] = 0 if character.always.include?('Innocent') 
    stats[:faith] = 100 if character.always.include?('Faith')

    stats
  end

  def formula
    skill.data['formula']
  end

  def recognized_formula?
    formula.match?(FORMULA_PATTERN)
  end

  def formula_function
    formula.match(FORMULA_PATTERN)[1]
  end

  def formula_expression
    formula.match(FORMULA_PATTERN)[2]
  end

  memoize def scalar
    case formula_function.downcase
    when 'dmg_f', 'heal_f', 'hit_f'
      Eqn::Calculator.calc(FAITH, **bindings)
    when 'dmg_p', 'heal_p', 'hit_p'
      Eqn::Calculator.calc(PALADIN, **bindings)
    when 'dmg_u', 'heal_u', 'hit_u'
      Eqn::Calculator.calc(UNFAITH, **bindings)
    else
      1
    end
  end
end
  
class Character::CalculateFormula < ActiveInteractor::Base
  RANGE_PATTERN = /\[?([\w\d]+)\.\.([\w\d]+)\]?/

  before_perform :mutate_skill, if: -> { skill.is_a?(Item) }
  
  delegate :character, :weapon, :skill, :bindings, :result,
    :scalar, :formula, :formula_expression, :recognized_formula?, to: :context

  def mutate_skill
    weapon = skill
      
    context.skill = Skill.new(
      data: {
        formula: "Dmg_(#{weapon.formula})",
        atk_up: !weapon.gun?,
        matk_up: weapon.gun? && weapon.formula.match?(/MA/),
        two_hands: true,
        martial_arts: 'If barehanded',
        element: weapon.data['element'],
        xa: weapon.data['xa']
      }
    )
  end

  def perform
    return unless recognized_formula?

    xa = skill.data['xa']&.downcase

    computed = if formula.match?(/requires sword/i) && !bindings[:weapons]&.any?(&:sword_or_katana?)
      '--'
    elsif xa.blank?
      calc("#{formula_expression.downcase} * scalar", scalar:, **bindings)
    elsif (matches = xa.match?(RANGE_PATTERN))
      min = matches[1]
      max = matches[2]

      xa_min = xa.gsub(RANGE_PATTERN, min)
      xa_ax = xa.gsub(RANGE_PATTERN, max)

      compute_range(xa, xa_min, xa_max)
    else
      compute(xa)
    end

    context.result = formula and return if computed.blank?

    context.result = formula.sub(formula_expression, "(#{computed.to_s})")
  end

  def compute(xa)
    x0 = eval_xa(xa)

    calc("#{formula_expression.downcase.sub(xa.downcase, x0.to_s)} * scalar", scalar:, **bindings)
  end

  def compute_range(xa, min, max)
    x0_min = eval_xa(min)
    x0_max = eval_xa(max)

    min_result = calc("#{formula_expression.sub(xa, x0_min)} * scalar", scalar:, **bindings)
    max_result = calc("#{formula_expression.sub(xa, x0_max)} * scalar ", scalar:, **bindings)

    min_result..max_result
  end

  def eval_xa(xa)
    x0 = calc(xa, **bindings)
    x0 = calc('x * 5/4', x: x0) if character.strengthens.include?(skill.data['element'])
    x0 = calc('x * 3/2', x: x0) if skill.data['two_hands'].present? && character.two_hands_engaged? && !character.weapon.data['flags']&.match('2-hands only')
    x0 = calc('x * 4/3', x: x0) if skill.data['atk_up'].present? && character.attack_up?
    x0 = calc('x * 5/4', x: x0) if skill.data['matk_up'].present? && character.m_attack_up?
    x0 = calc('x * 4/3', x: x0) if skill.data['martial_arts']&.match?(/yes/i) || skill.data['martial_arts']&.match?(/barehanded/i) && character.weapon.blank?

    x0
  end

  def calc(str, **options)
    Rails.logger.debug("calculating #{str.downcase} with bindings #{options.inspect}")
    Eqn::Calculator.calc("rounddown(#{str.downcase})", **options)
  rescue
    nil
  end
end
  