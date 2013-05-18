Kaeruspoon::Application.routes.draw do
  root to: 'articles#recent'

  resources :articles do
    collection do
      get 'popular' => 'articles#popular', as: :popular
      get 'archive' => 'articles#archive', as: :archive
      get 'date/:year/:month/(:day)' => 'articles#date', as: :date,
        year: /\d{4}/, month: /\d{1,2}/, day: /\d{1,2}/
    end
  end

  resources :photos

  get '/diary/:year/:month/(:day)' => redirect("/articles/date/%{year}/%{month}/%{day}")

  get 'manage' => 'manages#top', as: :manage
  resource :session
  resources :back_images

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root to: 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
