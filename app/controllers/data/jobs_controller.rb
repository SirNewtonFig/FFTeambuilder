class Data::JobsController < ApplicationController
  def index
    render json: Job.all.to_json
  end

  def simplified
    render json: Job.all.pluck(:id, :name).to_h.to_json
  end
end
