class Character::MemgenContext < ActiveInteractor::Context::Base
  attributes :character, :slot, :palette
  attribute :block, default: -> { [] }

  validates :character, :slot, :palette, presence: true
end

class Character::Memgen < ActiveInteractor::Base
  RAW_CONST = 1638400

  CHARACTER_SETS = {
    'm' => '80',
    'f' => '81',
    'x' => '82'
  }

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

  SKILLFLAGS_JOBS = ['4a','4b','4c','4d','4e','4f','50','51','52','53','54','55','56','57','58','59','5a','5b','5c']

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
    serialize_jp!
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
      block << CHARACTER_SETS[character.sex]
    end

    def serialize_roster_slot!      
      block << "%02x" % (slot + 8)
    end

    def serialize_primary!
      block << character.job.data.dig(character.sex, 'memgen_id')
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
      block << (character.secondary&.data&.dig(character.sex, 'secondary_id') || backup_secondary)
    end

    def backup_secondary
      return '00' if character.job.name == 'Mime' || character.job.monster?

      return '05' unless character.job.name == 'Squire'

      return '06'
    end

    def serialize_reaction!
      reaction = (character.reaction&.data&.dig('memgen_id') || '0000')

      block << little_endian(reaction, 2)
    end

    def serialize_support!
      support = (character.support&.data&.dig('memgen_id') || '0000')
      
      block << little_endian(support, 2)
    end

    def serialize_movement!
      movement = (character.movement&.data&.dig('memgen_id') || '0000')
      
      block << little_endian(movement, 2)
    end

    def serialize_helmet!
      block << (character.helmet&.data&.dig('memgen_id') || 'ff')
    end

    def serialize_armor!
      block << (character.armor&.data&.dig('memgen_id') || 'ff')
    end

    def serialize_accessory!
      block << (character.accessory&.data&.dig('memgen_id') || 'ff')
    end

    def serialize_rhand_weapon!
      if character.two_hands_engaged?
        block << character.weapon.data.dig('memgen_id') || 'ff'
      elsif character.rhand&.weapon?
        block << character.rhand.data.dig('memgen_id') || 'ff'
      else
        pad!('ff', 1)
      end
    end

    def serialize_rhand_shield!
      if character.rhand&.shield?
        block << character.rhand.data.dig('memgen_id') || 'ff'
      else
        pad!('ff', 1)
      end
    end

    def serialize_lhand_weapon!
      if character.two_hands_engaged? || !character.lhand&.weapon?
        pad!('ff', 1)
      else
        block << character.lhand.data.dig('memgen_id') || 'ff'
      end
    end

    def serialize_lhand_shield!
      if character.lhand&.shield?
        block << character.lhand.data.dig('memgen_id') || 'ff'
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

    def serialize_skills!
      pad!('00', 3)

      SKILLFLAGS_JOBS.each do |job|
        if job == character.job.data.dig(character.sex, 'memgen_id')
          encode_skills!(job, character.primary_skills)
        elsif job == character.secondary&.data&.dig(character.sex, 'memgen_id')
          encode_skills!(job, character.secondary_skills)
        else
          pad!('00', 3)
        end
      end
    end

    def encode_skills!(job, skills)
      value = skills
        .map{|s| s.data.dig('memgen_id').to_i(16) }
        .sum

      value = "%04x" % value

      block << value.first(2)
      block << value.last(2)
      block << '00'
    end

    def serialize_jp!
      pad!('88', 10)

      40.times do
        pad!('0F')
        pad!('27')
      end
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

    def little_endian(str, bytes)
      padded_str = "%0#{bytes * 2}x" % str.to_i(16)

      padded_str.scan(/(..)/).reverse.join
    end
end
