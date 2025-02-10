class Skill::ComputeFormulaContext < ActiveInteractor::Context::Base
  extend Memoist

  UNFAITH = '(100 - (faith-30) - 20)/100'
  FAITH = '(100 - (70-faith) - 20)/100'
  PALADIN = '(100 - (70-faith) - 20)/100'

  attribute :character
  attribute :skill
  attribute :expression
  attribute :result

  memoize def bindings
    stats = [:pa, :ma, :sp, :wp, :br, :faith].index_with { |key| character.send(key) }

    stats[:faith] = 0 if character.always.include?('Innocent') 
    stats[:faith] = 100 if character.always.include?('Faith')

    stats
  end

  def formula_function
    expression[:function]
  end

  def formula_expression
    expression[:expression]
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
  
class Skill::ComputeFormula < ActiveInteractor::Base
  RANGE_PATTERN = /\[?([\w\d]+)\.\.([\w\d]+)\]?/
  WEAPON_PATTERN = /Weapon(?: with )?([+-]\d WP)?/i

  delegate :character, :skill, :bindings, :result, :scalar, :formula_expression, :recognized_formula?, to: :context

  def perform
    xa = skill.data['xa']

    computed = if formula_expression.match(WEAPON_PATTERN)
      wp_modifier = Regexp.last_match.captures&.first
      
      weapon_results = character.weapons.map { |weapon|
        w = weapon.dup
        w.data['wp'] = weapon.data['wp'].to_i + wp_modifier.to_i if wp_modifier.present?

        Weapon::EvaluateFormula.perform(character:, weapon: w).result
      }

      min = weapon_results.map{ |r| r.try(:min) || r }.sum
      max = weapon_results.map{ |r| r.try(:max) || r }.sum

      min == max ? min : min..max
    elsif xa.blank?
      calc("#{formula_expression.downcase} * scalar", scalar:, **bindings)
    elsif (matches = xa.match?(RANGE_PATTERN))
      min = matches[1]
      max = matches[2]

      xa_min = xa.gsub(RANGE_PATTERN, min)
      xa_max = xa.gsub(RANGE_PATTERN, max)

      compute_range(xa, xa_min, xa_max)
    else
      compute(xa)
    end

    context.result = formula_expression and return if computed.blank?

    context.result = "(#{computed.to_s})"
  end

  def compute(xa)
    x0 = eval_xa(xa)

    calc("#{formula_expression.sub(xa, x0.to_s)} * scalar", scalar:, **bindings)
  end

  def compute_range(xa, min, max)
    x0_min = eval_xa(min)
    x0_max = eval_xa(max)

    min_result = calc("#{formula_expression.sub(xa, x0_min.to_s)} * scalar", scalar:, **bindings)
    max_result = calc("#{formula_expression.sub(xa, x0_max.to_s)} * scalar ", scalar:, **bindings)

    min_result..max_result
  end

  def eval_xa(xa)
    x0 = calc(xa, **bindings)
    x0 = calc('x * 5/4', x: x0) if character.strengthens.include?(skill.data['element']) || (skill.data['element'] =~ /weapon/i && character.strengthens.include?(character.weapon.data['element']))
    x0 = calc('x * 3/2', x: x0) if skill.data['two_hands'].present? && character.two_hands_engaged? && !character.weapon.data['flags']&.match('2-hands only')
    x0 = calc('x * 4/3', x: x0) if skill.data['atk_up'].present? && character.attack_up?
    x0 = calc('x * 5/4', x: x0) if skill.data['matk_up'].present? && character.m_attack_up?
    x0 = calc('x * 4/3', x: x0) if skill.data['martial_arts']&.match?(/yes/i) || skill.data['martial_arts']&.match?(/barehanded/i) && character.weapon.blank?
    x0 = calc('x * 4/3', x: x0) if skill.data['atk_up'].present? && character.sniper? && character.weapon.bow?

    x0
  end

  def calc(str, **options)
    Eqn::Calculator.calc("rounddown(#{str.downcase})", **options)
  rescue
    context.fail!
  end
end
  