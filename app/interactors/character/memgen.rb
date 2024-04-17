class Character::MemgenContext < ActiveInteractor::Context::Base
  attributes :character, :slot, :palette
  attribute :block, default: -> { [] }

  validates :character, :slot, :palette, presence: true
end

class Character::Memgen < ActiveInteractor::Base
  RAW_CONST = 1638400

  SEXES = {
    'm' => '80',
    'f' => '40',
    'x' => '20'
  }

  ZODIACS = {
    'aries' => '00',
    'taurus' => '10',
    'gemini' => '20',
    'cancer' => '30',
    'leo' => '40',
    'virgo' => '50',
    'libra' => '60',
    'scorpio' => '70',
    'sagittarius' => '80',
    'capricorn' => '90',
    'aquarius' => 'A0',
    'pisces' => 'B0'
  }

  TEXT_ENCODINGS = {
    "0" => '00',
    "1" => '01',
    "2" => '02',
    "3" => '03',
    "4" => '04',
    "5" => '05',
    "6" => '06',
    "7" => '07',
    "8" => '08',
    "9" => '09',
    "A" => '0A',
    "B" => '0B',
    "C" => '0C',
    "D" => '0D',
    "E" => '0E',
    "F" => '0F',
    "G" => '10',
    "H" => '11',
    "I" => '12',
    "J" => '13',
    "K" => '14',
    "L" => '15',
    "M" => '16',
    "N" => '17',
    "O" => '18',
    "P" => '19',
    "Q" => '1A',
    "R" => '1B',
    "S" => '1C',
    "T" => '1D',
    "U" => '1E',
    "V" => '1F',
    "W" => '20',
    "X" => '21',
    "Y" => '22',
    "Z" => '23',
    "a" => '24',
    "b" => '25',
    "c" => '26',
    "d" => '27',
    "e" => '28',
    "f" => '29',
    "g" => '2A',
    "h" => '2B',
    "i" => '2C',
    "j" => '2D',
    "k" => '2E',
    "l" => '2F',
    "m" => '30',
    "n" => '31',
    "o" => '32',
    "p" => '33',
    "q" => '34',
    "r" => '35',
    "s" => '36',
    "t" => '37',
    "u" => '38',
    "v" => '39',
    "w" => '3A',
    "x" => '3B',
    "y" => '3C',
    "z" => '3D',
    "!" => '3E',
    "?" => '40',
    "+" => '42',
    "'" => '93',
    "-" => 'D11D',
    "." => 'D9B6',
    " " => 'fa'
  }

  delegate :character, :slot, :palette, :block, to: :context

  def perform
    serialize_character_set!
    serialize_roster_slot!
    serialize_primary!
    serialize_palette!
    serialize_sex!
    pad!('00', 1)
    serialize_zodiac!
    serialize_secondary!
    serialize_reaction!
    serialize_support!
    serialize_movement!
    serialize_helmet!
    serialize_armor!
    serialize_accessory!
    serialize_rhand_weapon!
    serialize_rhand_shield!
    serialize_lhand_weapon!
    serialize_lhand_shield!
    serialize_exp!
    serialize_level!
    serialize_brave!
    serialize_faith!
    serialize_hp!
    serialize_mp!
    serialize_sp!
    serialize_pa!
    serialize_ma!
    serialize_skills!
    serialize_inventory!
    serialize_m_ev!
    serialize_rng_confidence!
    pad!('00', 50)
    pad!('88', 10)
    serialize_ai!
    serialize_name!
    pad!('00', 17)
  end

  private

    def pad!(byte, n = 1)
      n.times do
        block << byte
      end
    end

    def serialize_character_set!
      block << str_to_hex(character.job.data.dig(character.sex, 'character_set'), default: '80')
    end

    def serialize_roster_slot!      
      block << "%02x" % (slot + 8)
    end

    def serialize_primary!
      block << str_to_hex(character.job.data.dig(character.sex, 'memgen_id'))
    end

    def serialize_palette!
      block << "%02x" % (palette + 1)
    end

    def serialize_sex!
      block << SEXES[character.sex]
    end

    def serialize_zodiac!
      block << ZODIACS[character.zodiac]
    end

    def serialize_secondary!
      block << str_to_hex(character.secondary&.data&.dig(character.sex, 'secondary_id'), default: backup_secondary)
    end

    def backup_secondary
      return '00' if character.job.name == 'Mime' || character.job.monster?

      return '05' unless character.job.name == 'Squire'

      return '06'
    end

    def serialize_reaction!
      reaction = str_to_hex(character.reaction&.data&.dig('memgen_id'), bytes: 2)

      block << little_endian(reaction, 2)
    end

    def serialize_support!
      support = str_to_hex(character.support&.data&.dig('memgen_id'), bytes: 2)
      
      block << little_endian(support, 2)
    end

    def serialize_movement!
      movement = str_to_hex(character.movement&.data&.dig('memgen_id'), bytes: 2)
      
      block << little_endian(movement, 2)
    end

    def serialize_helmet!
      block << str_to_hex(character.helmet&.data&.dig('memgen_id'), default: 'ff')
    end

    def serialize_armor!
      block << str_to_hex(character.armor&.data&.dig('memgen_id'), default: 'ff')
    end

    def serialize_accessory!
      block << str_to_hex(character.accessory&.data&.dig('memgen_id'), default: 'ff')
    end

    def serialize_rhand_weapon!
      if character.two_hands_engaged?
        block << str_to_hex(character.weapon.data.dig('memgen_id'), default: 'ff')
      elsif character.rhand&.weapon?
        block << str_to_hex(character.rhand.data.dig('memgen_id'), default: 'ff')
      else
        pad!('ff', 1)
      end
    end

    def serialize_rhand_shield!
      if character.rhand&.shield?
        block << str_to_hex(character.rhand.data.dig('memgen_id'), default: 'ff')
      else
        pad!('ff', 1)
      end
    end

    def serialize_lhand_weapon!
      if character.two_hands_engaged? || !character.lhand&.weapon?
        pad!('ff', 1)
      else
        block << str_to_hex(character.lhand.data.dig('memgen_id'), default: 'ff')
      end
    end

    def serialize_lhand_shield!
      if character.lhand&.shield?
        block << str_to_hex(character.lhand.data.dig('memgen_id'), default: 'ff')
      else
        pad!('ff', 1)
      end
    end

    def serialize_exp!
      block << '63'
    end

    def serialize_level!
      block << '23'
    end

    def serialize_brave!
      block << character.brave.to_i.to_s(16)
    end

    def serialize_faith!
      block << character.faith.to_i.to_s(16)
    end

    def serialize_hp!
      hp = solve_for_x('hp', character.job_data['hp'].to_i).to_s(16)

      block << little_endian(hp, 3)
    end

    def serialize_mp!
      mp = solve_for_x('mp', character.job_data['mp'].to_i).to_s(16)
      
      block << little_endian(mp, 3)
    end

    def serialize_sp!
      sp = solve_for_x('sp', character.job_data['speed'].to_i).to_s(16)
      
      block << little_endian(sp, 3)
    end

    def serialize_pa!
      pa = solve_for_x('pa', character.job_data['attack'].to_i).to_s(16)
      
      block << little_endian(pa, 3)
    end

    def serialize_ma!
      ma = solve_for_x('ma', character.job_data['magic'].to_i).to_s(16)
      
      block << little_endian(ma, 3)
    end

    def solve_for_x(stat, val)
      (val.to_f * RAW_CONST / character.job_data["#{stat}_mult"].to_i).ceil
    end

    def serialize_inventory!
      inventory = character.job.name == 'Chemist' ? 16 : 8
        
      inventory += character.items.sum {|item| item.data['extra_items'].to_i }

      block << str_to_hex(inventory.to_s(16))
    end

    def serialize_m_ev!
      block << str_to_hex(character.job_data['m_evade'], default: '00', base: 10)
    end

    def serialize_rng_confidence!
      block << str_to_hex(character.data.dig('ai_values', 'rng_confidence').to_i, default: '02', base: 16)
    end

    def serialize_skills!
      pad!('00', 3)

      if character.job.monster?
        pad!('ff', 4)
      else
        encode_skills!(character.primary_skills)
        encode_skills!(character.secondary_skills)
      end
    end

    def encode_skills!(skills)
      value = skills
        .map{|s| s.data.dig('memgen_id').to_i(16) }
        .sum

      value = "%04x" % value

      block << value.first(2)
      block << value.last(2)
    end

    def serialize_ai!
      block << 'b80b' # 0000 + 3000 JP buffer
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'crystal').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'dead').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'weaken').to_i || 0))
      block << 'b80b'
      block << 'b80b'
      block << 'b80b'
      block << 'b80b'
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'petrify').to_i || 0))
      block << 'b80b'
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'sundown').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'confusion').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'stealth').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'discord').to_i || 0))
      block << 'b80b'
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'treasure').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'undead').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'float').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'reraise').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'transparent').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'berserk').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'chicken').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'frog').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'near-fatal').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'poison').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'regen').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'protect').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'shell').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'haste').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'slow').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'fatigue').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'sturdy').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'faith').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'innocent').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'charm').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'overload').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'don-t-move').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'don-t-act').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'reflect').to_i || 0))
      block << little_endian(jp_ai_value(character.data.dig('ai_values', 'death-sentence').to_i || 0))
    end

    def serialize_name!
      chars = character.name
        .chars
        .map{|c| TEXT_ENCODINGS[c] }
        .join
        .first(32)

      block << chars

      pad!('FE', 17 - chars.length/2)
    end

    def jp_ai_value(value)
      "%04x" % (value + 3000)
    end

    def little_endian(str, bytes = 2)
      padded_str = "%0#{bytes * 2}x" % str.to_i(16)

      padded_str.scan(/(..)/).reverse.join
    end

    def str_to_hex(str, bytes: 1, default: '00', base: 16)
      return default * bytes if str.blank?

      "%0#{bytes * 2}x" % str.to_i(base)
    end
end
