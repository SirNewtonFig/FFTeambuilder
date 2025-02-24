module HasSubmissions
  extend ActiveSupport::Concern

  included do
    def load_submissions
      @submissions = @event.submissions.queue_ordered.where(approved: nil).includes(:team)
      @bracket = @event.submissions.queue_ordered.where(approved: true).includes(:team)
      @cut_submissions = @event.submissions.queue_ordered.where(approved: false).includes(:team)
      @my_submissions = @event.submissions.joins(:team).where(teams: { user_id: Current.user.id }).includes(:team).order(:priority)
      @standings = @bracket.sort_by(&:rank)
    end
  end
end