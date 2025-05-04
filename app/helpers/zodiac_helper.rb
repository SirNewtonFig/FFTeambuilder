module ZodiacHelper
  COMPAT_CLASSES = {
    best: 'text-green-400',
    good: 'text-yellow-400',
    neutral: 'text-gray-400',
    bad: 'text-blue-400',
    worst: 'text-red-400'
  }.with_indifferent_access

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

  def compat_between(char1, char2)
    index1 = zodiacs.find_index(char1.zodiac)
    index2 = zodiacs.find_index(char2.zodiac)

    return 'neutral' if index1 == index2
    return 'good' if index1 % 4 == index2 % 4
    return 'best' if index1 % 6 == index2 % 6 && [char1.sex, char2.sex].sort == ['f', 'm']
    return 'worst' if index1 % 6 == index2 % 6 && char1.sex != 'x' && char1.sex == char2.sex
    return 'bad' if index1 % 3 == index2 % 3

    'neutral'
  end

  def compat_class(compat)
    COMPAT_CLASSES[compat]
  end
end
