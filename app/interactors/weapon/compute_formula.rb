class Weapon::ComputeFormulaContext < ActiveInteractor::Context::Base
  extend Memoist

  XA_PATTERN = /(.+)\s?\*\s?WP/i

  attribute :character
  attribute :weapon
  attribute :expression
  attribute :result
  attribute :wp_modifier, default: 0

  memoize def bindings
    stats = [:pa, :ma, :sp, :br, :faith].index_with { |key| character.send(key) }
    stats[:wp] = (weapon.data['wp'] || character.wp).to_i
    stats[:wp] += wp_modifier.to_i

    stats
  end

  memoize def xa
    expression.match(XA_PATTERN)[1]
  end
end

class Weapon::ComputeFormula < ActiveInteractor::Base
  RANGE_PATTERN = /\[?([\w\d]+)\.\.([\w\d]+)\]?/

  delegate :character, :weapon, :bindings, :expression, :result, :xa, to: :context
  delegate :formula, to: :weapon

  def perform
    computed = if xa.blank?
      calc(expression.downcase, **bindings)
    elsif (matches = xa.match(RANGE_PATTERN))
      min = matches[1]
      max = matches[2]

      xa_min = xa.gsub(RANGE_PATTERN, min)
      xa_max = xa.gsub(RANGE_PATTERN, max)

      compute_range(xa, xa_min, xa_max)
    else
      compute(xa)
    end

    context.result = expression and return if computed.blank?

    context.result = computed
  end

  def compute(xa)
    x0 = eval_xa(xa)

    calc(expression.sub(xa, x0.to_s), **bindings)
  end

  def compute_range(xa, min, max)
    x0_min = eval_xa(min)
    x0_max = eval_xa(max)

    min_result = calc(expression.sub(xa, x0_min.to_s), **bindings)
    max_result = calc(expression.sub(xa, x0_max.to_s), **bindings)

    min_result..max_result
  end

  def eval_xa(xa)
    x0 = calc(xa, **bindings)
    x0 = calc('x * 3/2', x: x0) if character.always.include?('Berserk') && !weapon.magic_gun?
    x0 = calc('x * 5/4', x: x0) if character.strengthens.include?(weapon.data['element'])
    x0 = calc('x * 3/2', x: x0) if character.two_hands_engaged? && !weapon.data['flags']&.match('2-hands only')
    x0 = calc('x * 4/3', x: x0) if character.attack_up? && !weapon.magic_gun?
    x0 = calc('x * 5/4', x: x0) if character.m_attack_up? && weapon.magic_gun?
    x0 = calc('x * 4/3', x: x0) if character.martial_arts? && character.unarmed?
    x0 = calc('x * 4/3', x: x0) if character.sniper? && character.weapon.bow?

    x0
  end

  def calc(str, **options)
    Eqn::Calculator.calc("rounddown(#{str.downcase})", **options)
  rescue
    context.fail!
  end
end
