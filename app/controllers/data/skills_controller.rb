class Data::SkillsController < ApplicationController
  def index
    render json: Skill.all.to_json
  end

  def simplified
    render json: Skill.all.pluck(:id, :name).to_h.to_json
  end
end
