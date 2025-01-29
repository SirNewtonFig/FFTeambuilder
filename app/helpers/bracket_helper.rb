module BracketHelper
  extend Memoist

  memoize def parse_bracket(event)
    return if event.data['live_bracket'].blank?

    uri = URI.parse(event.data['live_bracket'])
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    
    Nokogiri.parse(http.get(uri.request_uri).body).search('.tournament-bracket').first.tap do |xml|
      xml.css('[data-participant-id]').each do |n|
        n.attributes['class'] << ' group cursor-pointer'
        n.wrap("<a xlink:href='#{event_submission_path(event_id: event.id, id: Submission.find_by("data ->> 'challonge_player_id' = :id", id: n.attribute('data-participant-id').to_s).team_id)}'>")
      end

      xml.css('.match--player-name').each {|n| n.attributes['class'] << ' group-hover:!fill-orange-400' }
    end
  end
end
