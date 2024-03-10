class Data::MonsterSkillsController < ApplicationController
  def index
    render json: MonsterSkill.all.to_json
  end

  def simplified
    render json: MonsterSkill.all.pluck(:id, :name).to_h.to_json
  end
end
