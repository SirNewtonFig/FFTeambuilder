class Event::ShuffleBracket < Event::ChallongeBaseInteractor
  contextualize_with :'event/context'
  
  delegate :load_tournament, to: :context

  before_perform :set_credentials
  before_perform :load_tournament, if: -> { context.tournament.blank? }
  

  def perform
    Challonge::Participant.post(:randomize, tournament_id: tournament.id)
  end
end
