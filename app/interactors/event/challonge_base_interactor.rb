class Event::ChallongeBaseInteractor < ActiveInteractor::Base
  delegate :event, :tournament, to: :context

  private

    def set_credentials
      context.fail! if event.user.challonge_credential.blank?

      Challonge::API.username = event.user.challonge_credential.username
      Challonge::API.key = event.user.challonge_credential.key
    end
end
