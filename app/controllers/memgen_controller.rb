class MemgenController < ApplicationController
  def create
    data = params[:slot].map do |x|
      {
        team_a: Team.new(**YAML.safe_load_file(x[:team_a])),
        team_b: Team.new(**YAML.safe_load_file(x[:team_b])),
        title: x[:save_name]
      }
    end

    hexstr = Card::Memgen.perform(matchups: data).block.join

    begin
      cardfile = Tempfile.new('card', Rails.root.join('tmp'), binmode: true)
      cardfile.write([hexstr].pack('H*'))

      File.open(cardfile.path, 'rb') do |f|
        send_data(f.read, filename: 'Final_Fantasy_Tactics_USA.mcd')
      end
    ensure
      cardfile.close
      cardfile.unlink
    end
  end
end
