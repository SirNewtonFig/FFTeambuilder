module BracketHelper
  extend Memoist

  memoize def parse_bracket(event)
    return if event.bracket_url.blank?

    uri = URI.parse(event.bracket_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    
    Nokogiri.parse(http.get(uri.request_uri).body).search('.tournament-bracket').first.tap do |xml|
      xml.attributes['width'].value = (xml.attributes['width'].value.to_i + 200).to_s
      
      xml.css('[data-participant-id]').each do |n|
        n.attributes['class'] << ' group/player cursor-pointer'
        n.wrap("<a xlink:href='#{event_submission_path(event_id: event.id, id: Submission.find_by(external_id: n.attribute('data-participant-id').to_s).team_id)}'>")
      end

      xml.css('.match--player-name').each {|n| n.attributes['class'] << ' fill-gray-100 text-xs group-hover/player:fill-orange-400' }
    end
  end
end
