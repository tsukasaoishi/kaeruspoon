Rails.application.routes.draw do
  root 'articles#index'

  namespace :articles do
    resources :popular, only: %i(index)
    get 'date/:year/:month/(:day)' => 'date#index', as: :date,
      year: /\d{4}/, month: /\d{1,2}/, day: /\d{1,2}/
  end

  resources :articles do
    collection do
      get 'archive' => 'articles#archive', as: :archive
    end
  end

  resources :photos, only: [:create]
  resources :keywords, except: [:index]

  get 'about' => 'about#index', as: :about
  get 'manage' => 'manages#top', as: :manage
  resource :session, only: [:new, :create, :destroy]

  post 'amazon' => 'amazon#markdown', as: :amazon

  get '/diary/archive', to: redirect('articles/archive')
  get '/diary/:year/:month/:day', to: redirect("articles/date/%{year}/%{month}/%{day}")
  get '/diary/:year/:month', to: redirect("articles/date/%{year}/%{month}")
  get 'diaries.atom', to: redirect('articles.atom')
  get '/date/:year/:month/:day', to: redirect("articles/date/%{year}/%{month}/%{day}")
  get '/date/:year/:month', to: redirect("articles/date/%{year}/%{month}")
end
