class Event::Context < ActiveInteractor::Context::Base
  attributes :event, :tournament

  validates :event, presence: true

  def load_tournament
    fail! if event.data['challonge_tournament_id'].blank?

    self.tournament = Challonge::Tournament.find(event.data['challonge_tournament_id'])
  rescue ActiveResource::ResourceNotFound
    fail!
  end
end