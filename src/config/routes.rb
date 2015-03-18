Rails.application.routes.draw do

  get 'worlds/subclass'

  get 'worlds/contain'

  get 'worlds/add_schema'

  get 'worlds/import_world'

  get 'worlds/autocomplete'

  get 'worlds/select_schema'

  get 'worlds/populate_table_form'

  post 'worlds/populate_table'

  post 'worlds/edit_schema'

  post 'worlds/save_schema'

  post 'worlds/create'

  post 'worlds/save_world_import'

  post 'world_instances/create'

  get 'world_instances/subclass'

  get 'world_instances/contain'

  get 'world_instances/import_world'

  get 'world_instances/add_schema'

  get 'world_instances/select_schema'

  get 'world_instances/populate_table_form'

  post 'world_instances/populate_table'

  post 'world_instances/edit_schema'

  post 'world_instances/save_schema'

  get 'grid/join_grid'

  get 'grid/join_grid_request'

  get 'grid/join_grid_response'

  get 'grid/get_all_schemata'

  get 'grid/create_proxy'

  get 'grid/register_proxy'

  get 'grid/get_world_proxy_details'

  get 'world_admins/check_if_admin'

  get 'world_admins/add_access_rules'

  get 'world_admins/view_access_rules'

  post 'world_admins/list_roles_to_add_access_rules'

  post '/world_admins/submit_access_rules'

  get 'world_admins/get_type_location_of_role'

  get 'world_admins/check_package_name'

  get 'uris/show_slug/:slug', to:'uris#show_slug'

  get 'auth/:provider/callback', to: 'authentication#create'

  get 'auth/failure', to: redirect('/')

  get 'authentication/authenticate'

  post 'authentication/login'

  post 'authentication/logout'

  get 'authentication/check_user'

  get 'bootstrap/index'

  post 'bootstrap/join_frame'

  post 'bootstrap/new_frame'

  post 'display/index'

  get 'world_instances/register_new_user'

  post 'world_instances/add_new_user'

  get 'uris/:slug', to: 'display#index', as: ''


  resources :notifications

  resources :events

  resources :proxy_worlds

  resources :world_imports

  resources :world_admins

  resources :worlds

  resources :uris
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'bootstrap#index'

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
