class Events::MemgenController < ApplicationController
  include HasMemgen

  before_action :load_event

  def create
    data = params[:slot].map do |x|
      sub_a = @event.submissions.find_by(external_id: x[:team_a])
      sub_b = @event.submissions.find_by(external_id: x[:team_b])
      {
        team_a: sub_a.team,
        team_b: sub_b.team,
        title: [sub_a.player_name_override, sub_b.player_name_override].join(' v ')
      }
    end

    generate_card(data)
  end

  private

    def load_event
      @event = Event.find(params[:event_id])
    end
end
