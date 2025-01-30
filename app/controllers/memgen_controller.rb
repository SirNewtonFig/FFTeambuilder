class MemgenController < ApplicationController
  include HasMemgen

  def create
    data = params[:slot].map do |x|
      {
        team_a: Team.new(**YAML.safe_load_file(x[:team_a])),
        team_b: Team.new(**YAML.safe_load_file(x[:team_b])),
        title: x[:save_name]
      }
    end

    generate_card(data)
  end
end
