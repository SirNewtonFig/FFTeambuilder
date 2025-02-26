module Admin
  class SeedsController < Admin::ApplicationController
    helper :form

    def index
      # no-op
    end

    def create
      Data::ImportSeeds.perform(zip: params[:zipfile])

      redirect_to admin_jobs_path
    end

    def download
      result = Data::ExportSeeds.perform

      send_data(result.io.read, filename: 'seeds.zip')
    end
  end
end
