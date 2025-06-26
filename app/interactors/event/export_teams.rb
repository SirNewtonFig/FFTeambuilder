require 'zip'
require 'csv'

class Event::ExportTeams < ActiveInteractor::Base
  extend Memoist

  BASE_TMP_DIR = Rails.root.join('tmp/cache/teams').to_s

  class Context < ActiveInteractor::Context::Base
    attributes :event, :io
    validates :event, presence: true
  end

  delegate :event, to: :context
  delegate :submissions, to: :event

  def perform
    prepare_tmp_dir
    prepare_bracket
    prepare_preseason
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
      Tempfile.open(['teams', '.zip'], BASE_TMP_DIR)
    end

    def cleanup
      FileUtils.remove_entry(tmp_dir)
    end

    def prepare_bracket
      bracket = submissions.queue_ordered.where(approved: true)

      return if bracket.none?

      FileUtils.mkdir_p(File.join(tmp_dir, 'Bracket'))

      bracket.each do |submission|
        team = submission.team
        filename = "#{submission.player_display_name} - #{submission.team_display_name}.yml"

        File.write(File.join(tmp_dir, 'Bracket', filename), team.attributes.except('id', 'created_at', 'updated_at', 'user_id').to_yaml)
      end
    end

    def prepare_preseason
      preseason = submissions.queue_ordered.where(approved: false)

      return if preseason.none?

      FileUtils.mkdir_p(File.join(tmp_dir, 'Preseason'))

      preseason.each do |submission|
        team = submission.team
        filename = "#{submission.player_display_name} - #{submission.team_display_name}.yml"

        File.write(File.join(tmp_dir, 'Preseason', filename), team.attributes.except('id', 'created_at', 'updated_at', 'user_id').to_yaml)
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
