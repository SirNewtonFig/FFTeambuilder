class Data::ItemsController < ApplicationController
  def index
    render json: Item.joins(:jobs)
      .select('items.*, array_agg(jobs.id) as job_ids')
      .group('items.id')
      .order('items.id')
      .all.to_json
  end

  def simplified
    render json: Item.all.pluck(:id, :name).to_h.to_json
  end
end
