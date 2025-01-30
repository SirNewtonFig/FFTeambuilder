class Event::Destroy < Event::ChallongeBaseInteractor
  contextualize_with :'event/context'
  
  delegate :load_tournament, to: :context

  before_perform :set_credentials
  before_perform :load_tournament, if: -> { context.tournament.blank? }
  

  def perform
    tournament.destroy
  end
end
