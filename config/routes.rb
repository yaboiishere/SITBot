Rails.application.routes.draw do
  resources :toilets
  resources :gifs
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  root 'gifs#index'
  get "/discord_start" => "botcontrol#discord_start"
  get "/discord_stop" => "botcontrol#discord_stop"
  get "/updatedoc" => "docs#update"

  telegram_webhook TelegramWebhooksController
  get "/update" => "gifgetter#gifchecker"
  get '/:id' => "shortener/shortened_urls#show"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
