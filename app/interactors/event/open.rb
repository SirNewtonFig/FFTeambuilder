class Event::Open < Event::ChallongeBaseInteractor
  contextualize_with :'event/context'
  
  delegate :event, :load_tournament, to: :context

  before_perform :set_credentials
  before_perform :load_tournament, if: -> { context.tournament.blank? }
  

  def perform
    tournament.post(:open_for_predictions)

    event.update(state: 'started')
  end
end
