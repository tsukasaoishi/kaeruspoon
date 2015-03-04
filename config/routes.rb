Rails.application.routes.draw do
  root 'articles#index'

  resources :articles do
    collection do
      get 'popular' => 'articles#popular', as: :popular
      get 'archive' => 'articles#archive', as: :archive
      get 'date/:year/:month/(:day)' => 'articles#date', as: :date,
        year: /\d{4}/, month: /\d{1,2}/, day: /\d{1,2}/
    end
  end

  resources :photos
  resources :keywords

  get 'about' => 'about#index', as: :about
  get 'manage' => 'manages#top', as: :manage
  resource :session

  post 'amazon' => 'amazon#markdown', as: :amazon

  get '/diary/archive', to: redirect('articles/archive')
  get '/diary/:year/:month/(:day)', to: redirect("date/:year/:month/(:day)")
end
