Rails.application.routes.draw do
  get root to: 'top#index'
  devise_for :users, controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }
end
