class Data::MonsterPassivesController < ApplicationController
  include BypassAuth

  def index
    render json: MonsterPassive.all.to_json
  end

  def simplified
    render json: MonsterPassive.all.pluck(:id, :name).to_h.to_json
  end
end
