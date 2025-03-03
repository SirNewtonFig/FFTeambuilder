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
        n.wrap("<a data-action='click->bracket#pick' data-player-id='#{n.attribute('data-participant-id')}' xlink:href='#{event_submission_path(event_id: event.id, id: n.attribute('data-participant-id').value.to_i, external: true)}'>")
      end

      xml.css('.match--player-name:not(.-placeholder)').each {|n| n.attributes['class'] << ' fill-gray-100 text-xs group-hover/player:fill-orange-400' }
    end
  end

  def rank_class(submission)
    return 'bg-gradient-to-b from-gold-light to-gold-dark' if submission.rank == 1

    return 'bg-gradient-to-b from-silver-light to-silver-dark' if submission.rank == 2

    return 'bg-gradient-to-b from-bronze-light to-bronze-dark' if submission.rank == 3

    'bg-gray-700'
  end
end
