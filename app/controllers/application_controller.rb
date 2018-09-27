class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def record_not_found
    render json: {
      body: 'RecordNotFound'
    }, status: 404
  end
  
  #Render JSON with response for a single object
  def render_resource(resource)
    if resource.errors.empty?
      render json: resource
    else
      validation_error(resource)
    end
  end

  #Format for errors validations
  def validation_error(resource)
    render json: {
      errors: [
        {
          status: '400',
          title: 'Bad Request',
          detail: resource.errors,
          code: '100'
        }
      ]
    }, status: :bad_request
  end

  #If it isn't user authenticated return 401 or if it isn't brand authenticated return 403
  def authenticate_company!
    authenticate_user!
    unless current_user.rol == "company"
      render json: {
      body: "You haven't permissions."
    }, status: :forbidden
    end
  end

  #If it isn't user authenticated return 401 or if it isn't candidate authenticated return 403
  def authenticate_candidate!
    authenticate_user!
    unless current_user.rol == "candidate"
      render json: {
      body: "You haven't permissions."
    }, status: :forbidden
    end
  end

  protected
    #Additional Parameters for devise creation users
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:rol])
    end
end