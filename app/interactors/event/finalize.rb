class Event::Finalize < Event::ChallongeBaseInteractor
  extend Memoist

  contextualize_with :'event/context'

  delegate :event, :load_tournament, to: :context

  before_perform :set_credentials
  before_perform :load_tournament, if: -> { context.tournament.blank? }


  def perform
    tournament.finalize!

    event.update(status: 'closed')

    scrape_results!
  end

  private

    def scrape_results!
      rankings.each do |ranking|
        participants.find_by(external_id: ranking.id)
          .update(rank: ranking.final_rank)
      end
    end

    def participants
      event.submissions
        .where(approved: true)
    end

    memoize def rankings
      tournament.participants
    end
end
