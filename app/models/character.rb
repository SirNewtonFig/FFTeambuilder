class Character
  extend Memoist

  DEFAULT_DATA = {
    job: 1,
    brave: 50,
    faith: 50,
    secondary: 2,
    reaction: nil,
    support: nil,
    movement: nil,
    skills: {
      primary: [],
      secondary: []
    },
    rhand: nil,
    lhand: nil,
    helmet: nil,
    armor: nil,
    accessory: nil
  }

  ZODIACS = {
    'aries' => 0x00,
    'taurus' => 0x10,
    'gemini' => 0x20,
    'cancer' => 0x30,
    'leo' => 0x40,
    'virgo' => 0x50,
    'libra' => 0x60,
    'scorpio' => 0x70,
    'sagittarius' => 0x80,
    'capricorn' => 0x90,
    'aquarius' => 0xA0,
    'pisces' => 0xB0
  }

  ELEMENTS = [
    'Fire',
    'Water',
    'Lightning',
    'Dark',
    'Holy'
  ]

  attr_accessor :data

  def self.blank_character
    new(DEFAULT_DATA.merge(
      name: Faker::Name.first_name_neutral,
      sex: ['m', 'f'].sample,
      zodiac: ZODIACS.keys.sample,
      ai_values: Status.default_priorities.merge(rng_confidence: '2')
    ).stringify_keys)
  end

  def initialize(data)
    @data = data
  end

  def name
    data['name']
  end

  memoize def job
    Job.find(data['job'])
  end

  def sex
    data['sex']
  end

  def generic?
    ['m', 'f'].include?(sex)
  end

  def monster?
    sex == 'x'
  end

  def brave
    data['brave']
  end
  alias_method :br, :brave

  def faith
    data['faith']
  end
  alias_method :fa, :faith

  def zodiac
    data['zodiac']
  end

  def hp
    job_data['hp'].to_i +
      items.map{|i| i.data['hp'].to_i}.sum +
      sum_passive('hp')
  end

  def mp
    job_data['mp'].to_i +
      items.map{|i| i.data['mp'].to_i}.sum +
      sum_passive('mp')
  end

  def move
    job_data['move'].to_i +
      items.map{|i| i.data['move'].to_i}.sum +
      rsm.map{|s| s.data.dig('move').to_i || 0 }.sum +
      sum_passive('move')
  end

  def jump
    job_data['jump'].to_i +
      items.map{|i| i.data['jump'].to_i}.sum +
      rsm.map{|s| s.data.dig('jump').to_i || 0 }.sum +
      sum_passive('jump')
  end

  def speed
    job_data['speed'].to_i +
      items.map{|i| i.data['speed'].to_i}.sum +
      sum_passive('speed')
  end
  alias_method :sp, :speed

  def magic
    job_data['magic'].to_i +
      items.map{|i| i.data['magic'].to_i}.sum +
      sum_passive('magic')
  end
  alias_method :ma, :magic

  def attack
    job_data['attack'].to_i +
      items.map{|i| i.data['attack'].to_i}.sum +
      sum_passive('attack')
  end
  alias_method :pa, :attack

  def class_evade
    job_data['evade'].to_i +
      sum_passive('ev_p')
  end

  def class_m_evade
    job_data['m_evade'].to_i +
      sum_passive('ev_m')
  end

  def shield_evade_physical
    return 0 unless shield.present?

    shield.data['ev_p'] || 0
  end

  def shield_evade_magical
    return 0 unless shield.present?

    shield.data['ev_m'] || 0
  end

  def accessory_evade_physical
    return 0 unless accessory.present?

    accessory.data['ev_p'] || 0
  end

  def accessory_evade_magical
    return 0 unless accessory.present?

    accessory.data['ev_m'] || 0
  end

  def wp
    return pa * br / 100 if weapon.blank?

    weapon.data['wp'].to_i
  end

  def wp_right
    return 0 unless rhand.present? && rhand.weapon?

    rhand.data['wp']
  end

  def wp_left
    return 0 unless lhand.present? && lhand.weapon?

    lhand.data['wp']
  end

  def w_ev_right
    return 0 unless rhand.present? && rhand.weapon?

    rhand.data['w_ev']
  end

  def w_ev_left
    return 0 unless lhand.present? && lhand.weapon?

    lhand.data['w_ev']
  end

  def job_data
    job.data[sex]
  end

  memoize def items
    [rhand, lhand, helmet, armor, accessory].compact
  end

  memoize def shield
    return rhand if rhand&.shield?

    lhand if lhand&.shield?
  end

  memoize def weapon
    return rhand if rhand&.weapon?

    lhand if lhand&.weapon?
  end

  memoize def weapons
    [rhand, lhand].compact.select(&:weapon?)
  end

  memoize def rhand
    Item.find(data['rhand']) if data['rhand'].present?
  end

  memoize def lhand
    Item.find(data['lhand']) if data['lhand'].present?
  end

  memoize def helmet
    Item.find(data['helmet']) if data['helmet'].present?
  end

  memoize def armor
    Item.find(data['armor']) if data['armor'].present?
  end

  memoize def accessory
    Item.find(data['accessory']) if data['accessory'].present?
  end

  memoize def secondary
    Job.find(data['secondary']) if data['secondary'].present?
  end

  memoize def reaction
    Skill.find(data['reaction']) if data['reaction'].present?
  end

  memoize def support
    Skill.find(data['support']) if data['support'].present?
  end

  memoize def movement
    Skill.find(data['movement']) if data['movement'].present?
  end

  memoize def rsm
    Skill.where(id: data.values_at('reaction', 'support', 'movement').compact)
  end

  memoize def primary_skills
    Skill.where(job: job, id: data.dig('skills','primary')&.map(&:to_i))
  end

  memoize def secondary_skills
    return [] if secondary.blank?

    Skill.where(job: secondary, id: data.dig('skills','secondary')&.map(&:to_i))
  end

  memoize def actions
    primary_skills | secondary_skills
  end

  memoize def monster_passives
    return [] if generic?

    MonsterPassive.where(job: job, id: data.dig('skills','secondary')&.map(&:to_i))
  end

  memoize def primary_skill_ids
    return [] if data.dig('skills', 'primary').blank?

    data.dig('skills', 'primary').map(&:to_i)
  end

  memoize def secondary_skill_ids
    return [] if data.dig('skills', 'secondary').blank?
    
    data.dig('skills', 'secondary').map(&:to_i)
  end

  memoize def strengthens
    return ELEMENTS if items.any? { |item| item.data['strengthens']&.match?(/all/i) }

    items.flat_map { |item| item.data['strengthens']&.split(/[\s\/]+/) }.compact.uniq
  end

  memoize def always
    items.flat_map { |item| item.data['always']&.split(/[\s\/]+/) }.compact.uniq
  end

  def can_equip_skills?
    job.name != 'Mime'
  end

  def can_equip_items?
    job.name != 'Mime'
  end

  def two_hands_engaged?
    return false if weapon.blank?

    (two_hands? || weapon.data['flags']&.match('2-hands only')) &&
      [lhand, rhand].compact.count == 1 &&
      weapon.data['flags']&.match('2-hands')
  end

  def sniper?
    movement&.name&.match?('Sniper') || job.innate_skills.exists?(name: 'Sniper')
  end
  
  def attack_up?
    support&.name&.match?('Attack UP') || job.innate_skills.exists?(name: 'Attack UP')
  end
  
  def m_attack_up?
    support&.name&.match?('Magic AttackUP') || job.innate_skills.exists?(name: 'Magic AttackUP')
  end
  
  def two_hands?
    support&.name&.match('Two Hands') || job.innate_skills.exists?(name: 'Two Hands')
  end

  def martial_arts?
    support&.name&.match('Martial Arts') || job.innate_skills.exists?(name: 'Martial Arts')
  end

  def two_swords?
    support&.name&.match('Two Swords') || job.innate_skills.exists?(name: 'Two Swords')
  end

  def sum_passive(stat)
    return 0 unless monster?

    monster_passives.map{|i| i.data[stat].to_i}.sum
  end

  def enforce_exclusions!(support_changed = false)
    return if generic?
    return unless monster_passives.joins(:exclusions).pluck(Arel.sql('distinct exclusions.ability_b_id')).include?(data['support'].to_i)

    if support_changed
      passives = monster_passives.joins(:exclusions).where(exclusions: { ability_b_id: data['support'].to_i}).pluck(:id)

      data['skills']['secondary'] = data['skills']['secondary'].map(&:to_i) - passives
    else
      data['support'] = nil
    end
  end

  def enforce_constraints!
    flush_cache

    data['brave'] = [[brave.to_i, 30].max, 70].min
    data['faith'] = [[faith.to_i, 30].max, 70].min

    if data['sex'] == 'x'
      enforce_monster_stuff! 
    else
      enforce_generic_stuff!
    end
  end

  def enforce_monster_stuff!
    data['job'] = Job.monster.order(:id).first.id if job.generic?

    data['skills']['primary'] = primary_skills.pluck(:id)
    data['skills']['secondary'] = monster_passives.pluck(:id)

    data['secondary'] = nil
    data['reaction'] = nil unless Skill.reaction.exists?(job: job, id: data['reaction'].to_i)
    data['support'] = nil unless Skill.support.exists?(job: job, id: data['support'].to_i)
    data['movement'] = nil unless Skill.movement.exists?(job: job, id: data['movement'].to_i)

    data['rhand'] = nil
    data['lhand'] = nil
    data['helmet'] = nil
    data['armor'] = nil
    data['accessory'] = nil

    flush_cache
  end

  def enforce_generic_stuff!
    data.merge!(DEFAULT_DATA.except(:name, :sex, :zodiac, :brave, :faith).stringify_keys) if job.monster?

    data['sex'] = 'm' if job.name == 'Bard'
    data['sex'] = 'f' if job.name == 'Dancer'

    data['skills']['primary'] = primary_skills.pluck(:id)
    data['skills']['secondary'] = secondary_skills.pluck(:id)

    data['secondary'] = nil unless Job.secondary(self).valid(self).exists?(id: data['secondary'].to_i)
    data['reaction'] = nil unless Skill.reaction.valid(self).exists?(id: data['reaction'].to_i)
    data['support'] = nil unless Skill.support.valid(self).exists?(id: data['support'].to_i)
    data['movement'] = nil unless Skill.movement.valid(self).exists?(id: data['movement'].to_i)

    data['rhand'] = nil unless Item.rhand(self).exists?(id: data['rhand'].to_i)
    data['lhand'] = nil unless Item.lhand(self).exists?(id: data['lhand'].to_i)
    data['helmet'] = nil unless Item.proficient(self).exists?(id: data['helmet'].to_i)
    data['armor'] = nil unless Item.proficient(self).exists?(id: data['armor'].to_i)
    data['accessory'] = nil unless Item.proficient(self).exists?(id: data['accessory'].to_i)

    flush_cache
  end

  memoize def jp_total
    raw_cost = job.data[sex]['jp_cost']

    raw_cost.to_i + jp_spread.values.sum
  end

  memoize def jp_spread
    return Job::CalculateSkillJp.perform(character: self).jp unless generic?

    job_prereqs = Job::CalculatePrerequisiteJp.perform(job: job).jp

    skill_costs = Job::CalculateSkillJp.perform(character: self).jp

    skill_prereq_costs = skill_costs.keys.map do |j|
      Job::CalculatePrerequisiteJp.perform(job: j).jp
    end

    total_costs = [job_prereqs, skill_costs, *skill_prereq_costs].each_with_object({}) do |splat, memo|
      splat.each do |job, jp|
        memo[job] = jp if memo[job].to_i < jp
      end
    end
  end

  memoize def jp_summary
    return {} unless generic?

    job_prereqs = Job::CalculatePrerequisiteJp.perform(job: job).jp

    skill_costs = Job::CalculateSkillJp.perform(character: self).jp

    skill_prereq_costs = skill_costs.keys.map do |j|
      Job::CalculatePrerequisiteJp.perform(job: j).jp
    end

    prereq_costs = [job_prereqs, *skill_prereq_costs].each_with_object({}) do |splat, memo|
      splat.each do |job, jp|
        memo[job] = jp if memo[job].to_i < jp
      end
    end

    {
      prereq_costs: prereq_costs,
      skill_costs: skill_costs
    }
  end

  memoize def unlock_costs
    Character::CalculateUnlockJp.perform(character: self).spread
  end

  def encode_character_set
    return 0x82 if job.monster?

    0x80
  end
end
