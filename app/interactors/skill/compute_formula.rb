class Skill::ComputeFormulaContext < ActiveInteractor::Context::Base
  extend Memoist

  UNFAITH_MIN = '(100 - (faith-30) - 40)/100'
  FAITH_MIN = '(100 - (70-faith) - 40)/100'
  PALADIN_MIN = '(100 - (70-faith) - 40)/100'

  UNFAITH_MAX = '(100 - (faith-30))/100'
  FAITH_MAX = '(100 - (70-faith))/100'
  PALADIN_MAX = '(100 - (70-faith))/100'

  attribute :character
  attribute :skill
  attribute :expression
  attribute :result

  memoize def bindings
    stats = [:pa, :ma, :sp, :wp, :br, :jmp, :faith].index_with { |key| character.send(key) }

    stats[:faith] = 0 if character.always.include?('Innocent')
    stats[:faith] = 100 if character.always.include?('Faith')

    stats
  end

  def formula_function
    expression[:function]
  end

  def formula_expression
    expression[:expression].gsub(/%/, '')
  end

  memoize def scalar_min
    case formula_function.downcase
    when 'dmg_f', 'heal_f', 'hit_f'
      Eqn::Calculator.calc(FAITH_MIN, **bindings)
    when 'dmg_p', 'heal_p', 'hit_p'
      Eqn::Calculator.calc(PALADIN_MIN, **bindings)
    when 'dmg_u', 'heal_u', 'hit_u'
      Eqn::Calculator.calc(UNFAITH_MIN, **bindings)
    else
      1
    end
  end

  memoize def scalar_max
    case formula_function.downcase
    when 'dmg_f', 'heal_f', 'hit_f'
      Eqn::Calculator.calc(FAITH_MAX, **bindings)
    when 'dmg_p', 'heal_p', 'hit_p'
      Eqn::Calculator.calc(PALADIN_MAX, **bindings)
    when 'dmg_u', 'heal_u', 'hit_u'
      Eqn::Calculator.calc(UNFAITH_MAX, **bindings)
    else
      1
    end
  end
end

class Skill::ComputeFormula < ActiveInteractor::Base
  WEAPON_PATTERN = /Weapon(?: with )?([+-]\d WP)?/i

  delegate :character, :skill, :bindings, :result, :scalar_min, :scalar_max, :formula_function, :formula_expression, to: :context

  def perform
    xa = skill.data['xa']

    computed = if formula_expression.match(WEAPON_PATTERN)
      wp_modifier = Regexp.last_match.captures&.first || 0

      weapon_results = character.weapons.map { |weapon|
        w = weapon.dup
        w.data['wp'] = character.wp if weapon.name == Item.fist.name

        Weapon::EvaluateFormula.perform(character:, weapon: w, wp_modifier:).result
      }

      min = weapon_results.map{ |r| r.try(:min) || r }.sum
      max = weapon_results.map{ |r| r.try(:max) || r }.sum

      min == max ? min : min..max
    elsif formula_function.match?('Dmg') && skill.data['range'] == 'Weapon' && !skill.formula.match?(/fails if target not/i)
      weapon_results = character.weapons.map { |weapon|
        wp = weapon.data['wp'] || character.wp

        compute(xa, wp: wp.to_i)
      }

      weapon_results.sum
    elsif xa.blank?
      calc(formula_expression.downcase, **bindings)
    else
      compute(xa)
    end

    context.result = formula_expression and return if computed.blank?

    min = (computed.try(:min) || computed) * scalar_min
    max = (computed.try(:max) || computed) * scalar_max

    min = 0 if min.negative?

    computed = min == max ? min.to_i : min.to_i..max.to_i

    context.result = computed.to_s
  end

  def compute(xa, **binding_overrides)
    x0 = eval_xa(xa)

    calc(formula_expression.sub(xa, x0.to_s), **bindings.merge(binding_overrides))
  end

  def eval_xa(xa)
    return 0 if skill.requires_sword? && !character.weapons.any?(&:sword_or_katana?)

    x0 = calc(xa, **bindings)
    x0 = calc('x * 5/4', x: x0) if character.strengthens.include?(skill.data['element']) || (skill.data['element'] =~ /weapon/i && character.weapon.present? && character.strengthens.include?(character.weapon&.data['element']))
    x0 = calc('x * 3/2', x: x0) if skill.data['two_hands'].present? && character.two_hands_engaged? && !character.weapon.data['flags']&.match('2-hands only')
    x0 = calc('x * 4/3', x: x0) if skill.data['atk_up'].present? && character.attack_up?
    x0 = calc('x * 3/2', x: x0) if skill.requires_sword? && character.weapon&.name == 'Materia Blade'
    x0 = calc('x * 5/4', x: x0) if skill.data['matk_up'].present? && character.m_attack_up?
    x0 = calc('x * 3/2', x: x0) if character.martial_arts? && (skill.data['martial_arts']&.match?(/yes/i) || skill.data['martial_arts']&.match?(/barehanded/i) && character.weapon.blank?)
    x0 = calc('x * 4/3', x: x0) if skill.data['atk_up'].present? && character.sniper? && character.weapon.bow?

    x0
  end

  def calc(str, **options)
    Eqn::Calculator.calc("rounddown(#{str.downcase})", **options)
  rescue
    context.fail!
  end
end
