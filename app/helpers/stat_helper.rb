module StatHelper
  LABELS = {
    'attack' => 'PA',
    'magic' => 'MA',
    'speed' => 'Sp'
  }

  def stat_label(stat)
    LABELS[stat] || stat.titleize
  end
end
