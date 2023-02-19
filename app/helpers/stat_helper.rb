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
    'counter_magic' => 'Counter Magic?'
  }

  def stat_label(stat)
    LABELS[stat] || stat.titleize
  end
end
