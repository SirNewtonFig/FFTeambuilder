require 'csv'

class Data::Events::StandingsController < ApplicationController
  def index
    load_data

    csv = StringIO.new

    headers = ['Team Name','Rank']

    csv << CSV.generate_line(headers, encoding: 'utf-8')

    @submissions.each do |submission|
      row = [submission.team.name, submission.rank]
      csv << CSV.generate_line(row, encoding: 'utf-8')
    end

    csv.rewind

    send_data(csv.read, filename: "#{@event.title} Rankings.csv")
  end

  private

    def load_data
      @event = Event.find(params[:event_id])

      @submissions = @event.submissions.where(approved: true).order(:rank)
    end
end
