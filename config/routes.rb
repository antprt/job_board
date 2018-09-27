Rails.application.routes.draw do
  devise_for :users, skip: [:sessions, :registrations]
  devise_scope :user do
    post 'login' => 'sessions#create', as: 'user_session'
    delete 'logout' => 'registrations#destroy', as: 'destroy_user_session'
    post 'signup' => 'registrations#create', as: 'user_registration'
  end

  resources :job_adverts, only: [:index, :create]
  resources :applies, except: [:destroy]
end
