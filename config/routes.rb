Rails.application.routes.draw do
  root to: 'home#index'
  get ':url_slug-:match_id' => 'home#show', as: :show
  get 'quayso' => 'home#longphung'

  get 'get_customer' => 'home#get_customer'
  get 'video' => 'home#video'
end
