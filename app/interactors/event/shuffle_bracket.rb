class Event::ShuffleBracket < Event::ChallongeBaseInteractor
  contextualize_with :'event/context'
  
  delegate :load_tournament, to: :context

  before_perform :load_tournament, if: -> { context.tournament.blank? }

  def perform
    tournament.reset!
    
    Challonge::Participant.post(:randomize, tournament_id: tournament.id)

    tournament.start!
  end
end
