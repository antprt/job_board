class AppliesController < ApplicationController
  before_action :authenticate_company!, except: [:create]
  before_action :authenticate_candidate!, only: [:create]
  before_action :set_apply_from_company, only: [:show, :update]

  # GET /applies
  def index
    @applies = Apply.job_advert_from_company(current_user)
    render json: @applies
  end

  # GET /applies/1
  def show
    render json: @apply
  end

  # POST /applies
  def create
    @apply = current_user.apply.new(apply_params)
    @apply.status = "pending"
    @apply.save
    render_resource(@apply)
  end

  # PATCH/PUT /applies/1
  def update
    @apply.assign_attributes(apply_params)
    @apply.save
    render_resource(@apply)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_apply_from_company
      @apply = Apply.job_advert_from_company(current_user).find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def apply_params
      if current_user.rol == "company"
        params.require(:apply).permit(:status, :highlight)
      elsif current_user.rol == "candidate"
        params.require(:apply).permit(:job_advert_id)
      end
    end
end
