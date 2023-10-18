class Data::ItemsController < ApplicationController
  def index
    render json: Item.all.to_json
  end

  def simplified
    render json: Item.all.pluck(:id, :name).to_h.to_json
  end
end
