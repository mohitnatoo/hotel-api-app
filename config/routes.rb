Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :hotels, only: [] do
    resources :room_types, only: [] do
      resource :rate, only: [:update]

      resource :availability, only: [:show]

      resources :reservations, only: [:create]
    end
  end
end
