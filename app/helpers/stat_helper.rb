module StatHelper
  LABELS = {
    'attack' => 'PA',
    'magic' => 'MA',
    'speed' => 'Sp',
    'mp' => 'MP',
    'ct' => 'CT',
    'silence' => 'Silence?',
    'counter' => 'Counter?',
    'reflectable' => 'Reflect?',
    'counter_flood' => 'Counter Flood?',
    'counter_magic' => 'Counter Magic?',
    'atk_up' => 'Attack UP?',
    'matk_up' => 'Magic AttackUP?',
    'martial_arts' => 'Martial Arts?',
    'two_hands' => 'Two Hands?',
    'two_swords' => 'Two Swords?',
    'protect' => 'Protect?',
    'shell' => 'Shell?'
  }

  def stat_label(stat)
    LABELS[stat] || stat.titleize
  end
end
