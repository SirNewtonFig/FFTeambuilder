require 'zip'

class Data::ExportSeeds < ActiveInteractor::Base
  extend Memoist

  BASE_TMP_DIR = Rails.root.join('tmp/cache/seeds').to_s

  def perform
    prepare_tmp_dir
    prepare_files
    create_zip

    context.io = tmp_zip_file
  ensure
    cleanup
  end

  private

    def prepare_tmp_dir
      FileUtils.mkdir_p(BASE_TMP_DIR)
    end

    memoize def tmp_dir
      Dir.mktmpdir('export-', BASE_TMP_DIR)
    end

    memoize def tmp_zip_file
      Tempfile.open(['seeds', '.zip'], BASE_TMP_DIR)
    end

    def cleanup
      FileUtils.remove_entry(tmp_dir)
    end

    def prepare_files
      dir = FileUtils.mkdir_p(File.join(tmp_dir, 'seeds')).first

      FileUtils.mkdir_p(File.join(dir, 'items'))

      {
        Data::Export::ExportJobs => 'jobs.csv',
        Data::Export::ExportPrerequisites => 'prerequisites.csv',
        Data::Export::ExportSkills => 'skills.csv',
        Data::Export::Items::ExportAccessories => 'items/accessories.csv',
        Data::Export::Items::ExportArmor => 'items/armors.csv',
        Data::Export::Items::ExportHelmets => 'items/helmets.csv',
        Data::Export::Items::ExportShields => 'items/shields.csv',
        Data::Export::Items::ExportWeapons => 'items/weapons.csv',
        Data::Export::ExportMonsters => 'monsters.csv',
        Data::Export::ExportMonsterSkills => 'monster_skills.csv',
        Data::Export::ExportMonsterPassives => 'monster_passives.csv',
        Data::Export::ExportStatuses => 'statuses.csv'
      }.each do |kls, filename|
        File.write(File.join(dir, filename), kls.perform.io.read)
      end
    end

    def create_zip
      Zip::File.open(tmp_zip_file.path, create: true) do |zip|
        Dir.glob(File.join(tmp_dir, '**', '**'), File::FNM_DOTMATCH).each do |file|
          zip.add(file.remove(%r{^#{tmp_dir}/}), file)
        end
      end

      # rewind file pointer
      tmp_zip_file.open
    end
end
