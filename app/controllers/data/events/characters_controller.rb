require 'csv'

class Data::Events::CharactersController < ApplicationController
  def index
    load_data

    csv = StringIO.new

    headers = ['Team Name','Player Name','Palette A','Palette B','Unit Name','Sex','Zodiac','Brave','Faith','Job','Left Hand','Right Hand','Helmet','Armor','Support','Movement','Reaction','Accessory','Secondary',*(1..15).to_a.map{|s| "Primary#{s}"},*(1..15).to_a.map{|s| "Secondary#{s}"}]

    csv << CSV.generate_line(headers, encoding: 'utf-8')

    @teams.each do |team|
      team.characters.each do |c|
        primary_skill_ids = c.primary_skill_ids.reject(&:zero?)
        secondary_skill_ids = c.secondary_skill_ids.reject(&:zero?)

        row = [
          team.name,
          team.player_name,
          team.palette_a,
          team.palette_b,
          c.name,
          c.sex,
          c.zodiac,
          c.brave,
          c.faith,
          c.job.id,
          c.lhand&.id,
          c.rhand&.id,
          c.helmet&.id,
          c.armor&.id,
          c.support&.id,
          c.movement&.id,
          c.reaction&.id,
          c.accessory&.id,
          c.secondary&.id,
          *primary_skill_ids,
          *['']*(15 - primary_skill_ids.length),
          *secondary_skill_ids,
          *['']*(15 - secondary_skill_ids.length)
        ]

        csv << CSV.generate_line(row, encoding: 'utf-8')
      end
    end

    # raise 'hell'

    csv.rewind

    send_data(csv.read, filename: "#{@event.title}.csv")
  end

  private

    def load_data
      @event = Event.find(params[:event_id])

      @teams = @event.teams.where(submissions: { approved: true })
    end
end
