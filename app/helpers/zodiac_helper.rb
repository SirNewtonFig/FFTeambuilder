module ZodiacHelper
  def zodiacs
    Character::ZODIACS.keys
  end

  def good_compats(zodiac)
    mod = zodiacs.find_index(zodiac) % 4
    zodiacs.select{|z| z != zodiac && zodiacs.find_index(z) % 4 == mod }
  end

  def bad_compats(zodiac)
    mod = zodiacs.find_index(zodiac) % 3
    zodiacs.select{|z| z != zodiac && zodiacs.find_index(z) % 3 == mod && z != best_worst_compat(zodiac) }
  end

  def best_worst_compat(zodiac)
    mod = zodiacs.find_index(zodiac) % 6
    zodiacs.detect{|z| z != zodiac && zodiacs.find_index(z) % 6 == mod }
  end

  def best_compat_sex(char)
    (['m', 'f'] - [char.sex]).first.titlecase
  end

  def good_compat_teammates(char, team, zodiac)
    (team.characters - [char])
      .select{|c| good_compats(zodiac).include?(c.zodiac)}
  end

  def best_compat_teammates(char, team, zodiac)
    (team.characters - [char])
      .select{|c| best_worst_compat(zodiac) == c.zodiac && [c.sex, char.sex].sort == ['f', 'm']}
  end

  def bad_compat_teammates(char, team, zodiac)
    (team.characters - [char])
      .select{|c| bad_compats(zodiac).include?(c.zodiac) || (best_worst_compat(zodiac) == c.zodiac && [char.sex, c.sex].include?('x')) }
  end

  def worst_compat_teammates(char, team, zodiac)
    (team.characters - [char])
      .select{|c| best_worst_compat(zodiac) == c.zodiac && c.sex == char.sex && c.sex != 'x'}
  end
end
