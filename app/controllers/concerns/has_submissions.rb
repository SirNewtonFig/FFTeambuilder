module HasSubmissions
  extend ActiveSupport::Concern

  included do
    def load_submissions
      @submissions = @event.submissions.where(approved: nil).includes(:team)
      @bracket = @event.submissions.where(approved: true).includes(:team)
      @cut_submissions = @event.submissions.where(approved: false).includes(:team)
      @my_submissions = @event.submissions.joins(:team).where(teams: { user_id: Current.user.id }).includes(:team)
    end
  end
end