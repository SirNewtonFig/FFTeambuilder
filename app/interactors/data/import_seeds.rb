require 'zip'
require 'csv'

class Data::ImportSeeds < ActiveInteractor::Base
  extend Memoist

  BASE_TMP_DIR = Rails.root.join('tmp/cache/seeds').to_s

  MANIFEST = [
    'jobs.csv',
    'monster_passives.csv',
    'monster_skills.csv',
    'monsters.csv',
    'prerequisites.csv',
    'skills.csv',
    'statuses.csv',
    'accessories.csv',
    'armors.csv',
    'helmets.csv',
    'shields.csv',
    'weapons.csv'
  ]

  def perform
    prepare_tmp_dir
    extract_files
    import_seeds
  ensure
    cleanup
  end

  private

    def prepare_tmp_dir
      FileUtils.mkdir_p(BASE_TMP_DIR)
    end

    memoize def tmp_dir
      Dir.mktmpdir('import-', BASE_TMP_DIR)
    end

    def cleanup
      FileUtils.remove_entry(tmp_dir)
    end

    def extract_files
      FileUtils.mkdir_p(File.join(tmp_dir, 'seeds/items'))

      Zip::File.open(context.zip) do |zip_file|
        zip_file.each do |entry|
          name = File.basename(entry.name)
          puts "extracting #{name}"

          next unless MANIFEST.include?(name)

          entry.extract(File.join(tmp_dir, name))
        end
      end
    end

    def import_seeds
      jobs = CSV.parse(File.read(File.join(tmp_dir, 'jobs.csv')), headers: true)
      Data::Import::ImportJobs.perform(jobs:)

      Prerequisite.destroy_all
      prerequisites = CSV.parse(File.read(File.join(tmp_dir, 'prerequisites.csv')), headers: true)
      Data::Import::ImportPrerequisites.perform(prerequisites:)

      skills = CSV.parse(File.read(File.join(tmp_dir, 'skills.csv')), headers: true)
      Data::Import::ImportSkills.perform(skills:)

      items = {}
      ['accessories.csv', 'armors.csv', 'helmets.csv', 'shields.csv', 'weapons.csv'].each do |sheet|
        f = File.join(tmp_dir, sheet)
        items[File.basename(f, '.csv').singularize] = CSV.parse(File.read(f), headers: true)
      end
      Data::Import::ImportItems.perform(items:)

      monsters = CSV.parse(File.read(File.join(tmp_dir, 'monsters.csv')), headers: true)
      Data::Import::ImportMonsters.perform(monsters:)

      mskills = CSV.parse(File.read(File.join(tmp_dir, 'monster_skills.csv')), headers: true)
      Data::Import::ImportMonsterSkills.perform(mskills:)

      passives = CSV.parse(File.read(File.join(tmp_dir, 'monster_passives.csv')), headers: true)
      Data::Import::ImportMonsterPassives.perform(passives:)

      statuses = CSV.parse(File.read(File.join(tmp_dir, 'statuses.csv')), headers: true)
      Data::Import::ImportStatuses.perform(statuses:)

      Exclusion.find_or_create_by(
        ability_a: MonsterPassive.find_by(job: Job.find_by(name: 'Bomb'), name: 'AllDef+ Weak:Water'),
        ability_b: Skill.find_by(job: Job.find_by(name: 'Bomb'), name: 'Defense UP')
      )

      Data::Import::ImportInnates.perform
    end
end
