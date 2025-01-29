class Event::Publish < Event::ChallongeBaseInteractor
  contextualize_with :'event/context'

  def perform
    return if event.data['challonge_tournament_id'].present?

    create_tournament
    submit_participants
    randomize_seeds
    tournament.start!  
  end

  private

    def create_tournament
      t = Challonge::Tournament.new
      t.name = event.title
      t.url = event.slug
      t.tournament_type = 'double elimination'
      t.save

      raise t.errors.messages.values.flatten.join("\n") unless t.valid?

      event.update(data: { challonge_tournament_id: t.id, live_bracket: t.live_image_url })
      context.tournament = t
    end

    def submit_participants
      event.submissions.where(approved: true).each do |submission|
        p = Challonge::Participant.create(name: submission.display_name, tournament:, misc: submission.id)

        submission.update(data: { 'challonge_player_id' => p.id })
      end
    end

    def randomize_seeds
      Challonge::Participant.post(:randomize, tournament_id: context.tournament.id)
    end
end
