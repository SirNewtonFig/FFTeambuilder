module SpriteHelper
  SPRITE_ORDER = [
    'Squire',
    'Chemist',
    'Knight',
    'Archer',
    'Monk',
    'Priest',
    'Wizard',
    'Time Mage',
    'Summoner',
    'Thief',
    'Mediator',
    'Oracle',
    'Geomancer',
    'Lancer',
    'Samurai',
    'Ninja',
    'Sage',
    'Performer',
    'Mime',
    'Engineer',
    'Paladin',
    'Spellblade',
    'Warlock',
    'Blood Mage',
    'Chocobo',
    'Goblin',
    'Bomb',
    'Tonberry',
    'Mindflayer',
    'Skeleton',
    'Ghost',
    'Ahriman',
    'Juravis',
    'Piggy',
    'Treant',
    'Minotaur',
    'Malboro',
    'Behemoth',
    'Dragon',
    'Hydra'
  ].freeze

  COLOR_ORDER = [
    'black',
    'blue',
    'red',
    'green',
    'white',
    'purple',
    'yellow',
    'brown'
  ].freeze

  def sprite_style_for(team, job, sex = nil)
    "background-position: #{sprite_offset_x(job, sex)}px #{sprite_offset_y(team)}px"
  end

  def sprite_offset_x(job, sex)
    job_name = job.name
    job_name = 'Performer' if job.name.in?(['Bard', 'Dancer'])

    if job.generic?
      index = SPRITE_ORDER.index(job_name) * 2
      index += 1 if sex == 'f'
    else
      index = SPRITE_ORDER.index(job_name) + 24
    end

    return index * -45
  end

  def sprite_offset_y(team)
    COLOR_ORDER.index(team.palette_a) * -50
  end
end
