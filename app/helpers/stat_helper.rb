module StatHelper
  LABELS = {
    'attack' => 'PA',
    'magic' => 'MA',
    'speed' => 'SP',
    'mp' => 'MP',
    'ct' => 'CT',
    'reflectable' => 'Reflect',
    'atk_up' => 'Attack UP',
    'matk_up' => 'Magic AttackUP'
  }

  def stat_label(stat)
    LABELS[stat] || stat.titleize
  end
end
