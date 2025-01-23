module HasSubmissions
  extend ActiveSupport::Concern

  included do
    def load_submissions
      @submissions = Team.for_event(@event)
        .where(submissions: { approved: nil })
        
      @bracket = Team.for_event(@event)
        .where(submissions: { approved: true })
      
      @cut_submissions = Team.for_event(@event)
        .where(submissions: { approved: false })
    
      @my_submissions = Team.for_event(@event)
        .where(teams: { user_id: Current.user.id })
    end
  end
end