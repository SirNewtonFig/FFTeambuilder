module HasMemgen
  extend ActiveSupport::Concern

  included do
    def generate_card(data)
      hexstr = Card::Memgen.perform(matchups: data).block.join

      begin
        cardfile = Tempfile.new('card', Rails.root.join('tmp'), binmode: true)
        cardfile.write([hexstr].pack('H*'))

        File.open(cardfile.path, 'rb') do |f|
          send_data(f.read, filename: 'Final Fantasy Tactics (USA)_1.mcd')
        end
      ensure
        cardfile.close
        cardfile.unlink
      end
    end
  end
end