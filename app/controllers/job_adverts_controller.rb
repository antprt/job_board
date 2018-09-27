class JobAdvertsController < ApplicationController
  before_action :authenticate_company!, only: [:create]
  before_action :authenticate_candidate!, only: [:index]

  # POST /job_adverts
  def create
    @job_advert = current_user.job_advert.new(job_advert_params)

    @job_advert.save
    render_resource(@job_advert)
  end

  # GET /job_adverts
  def index
    render json: JobAdvert.all
  end

  private
    # Only allow a trusted parameter "white list" through.
    def job_advert_params
      params.require(:job_advert).permit(:title, :description)
    end
end
