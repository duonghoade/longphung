Rails.application.routes.draw do
  root to: 'home#index'
  get ':url_slug-:macth_id' => 'home#show', as: :show
  get 'longphung' => 'home#longphung'

  get 'get_customer' => 'home#get_customer'
end
