class Event::Publish < Event::ChallongeBaseInteractor
  contextualize_with :'event/context'

  before_perform :set_credentials

  def perform
    return if event.external_id.present?

    create_tournament
    submit_participants
    randomize_seeds
    prepare_preseason
  end

  private

    def create_tournament
      t = Challonge::Tournament.new
      t.name = event.title
      t.url = event.slug
      t.tournament_type = 'double elimination'
      t.prediction_method = 1
      t.save

      raise t.errors.messages.values.flatten.join("\n") unless t.valid?

      event.update(external_id: t.id, bracket_url: t.live_image_url, state: 'published')
      context.tournament = t
    end

    def submit_participants
      event.submissions.where(approved: true).each do |submission|
        p = Challonge::Participant.create(name: submission.player_name_override, tournament:, misc: submission.id)

        submission.update(external_id: p.id)
      end
    end

    def randomize_seeds
      Challonge::Participant.post(:randomize, tournament_id: context.tournament.id)
    end

    def prepare_preseason
      event.submissions.where(external_id: nil).update_all("external_id = id")
    end
end
