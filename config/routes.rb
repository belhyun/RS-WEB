RsWww::Application.routes.draw do
  apipie
  #devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase
  namespace :api do
    namespace :v1 do
      post 'users/sign_up' => 'users#signup'
      post 'users/sign_in' => 'users#signin'
      post 'users/sign_out' => 'users#signout'
      post 'users/email' => 'users#email'
      get 'users/:id' => 'users#show'
      post 'users/:user_id/routes' => 'users#routes'
      get  'users/:user_id/routes' => 'users#get_routes'
      post 'users/:user_id/profile' => 'users#profile'
      post 'users/:user_id/follow' => 'users#follow'
      get 'users/:user_id/follows' => 'users#follows'
      get 'users/:user_id/followers' => 'users#followers'
      post 'users/:user_id/nick' => 'users#change_nick'
      post 'tokens/valid' => 'tokens#valid'
      get 'subways/:id/list' => 'subways#list'
      get 'versions' => 'versions#index'
      get 'regions/list' => 'regions#list'
      get 'regions/routes' => 'regions#routes'
      get 'routes/:id/boards' => 'routes#boards'
      resources :boards do
        member do
          get 'comments'
        end
        post 'empathy' => 'boards#empathy'
      end
      resources :comments
    end
  end
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

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
