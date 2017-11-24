Rails.application.routes.draw do
  root 'articles#index'

  namespace :articles do
    resources :share, only: %i(index)
    resources :popular, only: %i(index)
    resources :archive, only: %i(index)
    get 'date/:year/:month/(:day)' => 'date#index', as: :date,
      year: /\d{4}/, month: /\d{1,2}/, day: /\d{1,2}/
  end

  resources :articles

  resource :tsukasa, only: %i(show)

  resources :photos, only: [:create]
  resources :keywords, except: [:index]

  get 'manage' => 'manages#top', as: :manage
  resource :session, only: [:new, :create, :destroy]

  post 'amazon' => 'amazon#markdown', as: :amazon

  get '/about', to: redirect('', status: 301)
  get '/diary/archive', to: redirect('articles/archive', status: 301)
  get '/diary/:year/:month/:day', to: redirect("articles/date/%{year}/%{month}/%{day}", status: 301)
  get '/diary/:year/:month', to: redirect("articles/date/%{year}/%{month}", status: 301)
  get 'diaries.atom', to: redirect('articles.atom', status: 301)
  get '/date/:year/:month/:day', to: redirect("articles/date/%{year}/%{month}/%{day}", status: 301)
  get '/date/:year/:month', to: redirect("articles/date/%{year}/%{month}", status: 301)
end
