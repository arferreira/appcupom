Appcupom::Application.routes.draw do

  resources :faqs

  match '/sobre', :to => 'static#sobre'

  match '/termos', :to => 'static#termos'

  match '/privacidade', :to => 'static#privacidade'

  match '/comofunciona', :to => 'static#comofunciona'
  #get "partner_password_resets/new"

  resources :cities

  resources :password_resets

  resources :partner_password_resets

  resources :payment_options

  resources :rules

  resources :mail_privacies

  resources :privacies

  resources :sub_categories

  resources :categories

  match '/sub_categories/for_categoryid/:category_id', :to => 'sub_categories#for_categoryid'

  #resources :product_types

  #resources :product_families

  resources :offer_comments

  resources :recommendations

  resources :facilities

  resources :badges

  resources :ads

  resources :clients

  resources :administrators do
    get 'dashboard', :on => :member
  end

  match '/aprovar', :to => 'administrators#pending_partners'
  match '/approve', :to => 'administrators#approve_partner'
  match '/listar_parceiros', :to => 'administrators#list_partners'

  match '/offers_by_date', :to => 'administrators#offers_date'

  resources :admin_roles

  resources :partner_comments
  post '/partners/postrequests', :to => "partners#index_posts"

  resources :partners do
    get 'dashboard', :on => :member
    get 'approve', :on => :member
    get 'deactivate', :on => :member
    resources :partner_comments
    resources :recommends

    #get 'waiting_approval', :on => :member
    resources :offers do
      resources :recommend_offers

      match '/stop', :to => 'offers#stop'
      match '/pause', :to => 'offers#pause'
      match '/restart', :to => 'offers#restart'
      match '/start', :to => 'offers#start'
    end

    resources :partner_pics

    resources :product_types do
      match '/deactivate', :to => 'product_types#deactivate'
      match '/activate', :to => 'product_types#activate'
    end

    resources :product_families do
      match '/deactivate', :to => 'product_families#deactivate'
      match '/activate', :to => 'product_families#activate'
    end

    match '/select_partner_pics', :to => 'partner_pics#select_partner_pics'
    match '/select_products', :to => 'products#select_products'
    match '/offers/:id/select_images', :to => 'offers#select_images'
    match '/offers/:id/select_products', :to => 'offers#select_products'
    match '/cupons', :to => 'cupons#validate_cupons'
    match '/set_distance', :to => 'offers#set_distance'
    match '/partner_pics/:id/destroy', :to => 'partner_pics#destroy'

    #recommands
    resources :recommend_partners
    match '/recommend_partners/:recommend_partners_id/unrecommend', :to => 'recommend_partners#unrecommend'

    resources :products do
      resources :recommend_products
      resources :wish_products

      match '/recommend_products/:recommend_products_id/unrecommend', :to => 'recommend_products#unrecommend'
      match '/wish_products/:wish_products_id/unwish', :to => 'wish_products#unwish'

      match '/deactivate', :to => 'products#deactivate'
      match '/activate', :to => 'products#activate'
    end
    resources :recommend_products, :only => :destroy
    resources :wish_products, :only => :destroy
  end

  match 'partners/:id', :to => 'partners#show', :via => :post

  #comments
  resources :rec_product_comments
  resources :rec_offer_comments
  resources :rec_partner_comments
  resources :wish_product_comments
  #destroy
  resources :recommend_partners, :only => :destroy
  #resources :offers, :only => :all
  match 'offers', :to => 'offers#nowon'
  match 'near_me', :to => 'offers#near_me'
  match 'category', :to => 'offers#category'
  match 'partners_near_me', :to => 'partners#near_me'
  match 'partners_category', :to => 'partners#category'

  resources :users do
    #get 'dashboard', :on => :member
    get 'badges',    :on => :member
    #get "cupons/index"
    #get "cupons/show"
    resources :cupons
    match '/old_cupons', :to => 'cupons#old_ones'
    match '/cupons/:id/printed', :to => 'cupons#printed'

    #friendship & Friend Requests
    get 'friend_requests', :on => :member
    get 'friends',         :on => :member
    get 'start_friendship', :on => :member
    get 'end_friendhip',   :on => :member
    get 'deny_friendhip',  :on => :member
    get 'timeline',        :on => :member
    get 'credits',         :on => :member
    get 'privacies',       :on => :member
    get 'remove_facebook', :on => :member
  end
  match '/users/:user_id/remove_card', :to => 'users#remove_card'
  match '/users/:id/edit_privacies',  :to => 'users#edit_privacies'

  resources :sessions, :only => [:create, :destroy]
  #resources :sessions, :only => [:new, :create, :destroy]

  match '/offers/:id', :to => 'offers#show'
  match '/offers/:id/buy', :to => 'cupons#buy'
  match '/offers/:id/confirm_printed', :to => 'cupons#confirm_printed'
  match '/offers/:id/buy_cupon', :to => 'cupons#buy_cupon'
  match '/offers/:id/payment_info', :to => 'offers#payment_info'
  match '/cupons/:id/confirmation', :to => 'cupons#confirmation'
  match '/cupons/:id/confirm_with_credit_only', :to => 'cupons#confirm_with_credit_only'
  match '/cupons/validate', :to => 'cupons#validate'
  match '/cupons/:user_id/validate_user_cupon', :to => 'cupons#validate_user_cupon'
  match '/cupons/:id/share_cupon', :to => 'cupons#share_cupon'

  match '/u/signup',  :to => 'users#new'
  match '/p/signup',  :to => 'partners#new'
  match '/a/signup',  :to => 'administrators#new'

  match '/:access_type/signin',  :to => 'sessions#new'
  match '/signin.:access_type',  :to => 'sessions#new'
  match '/signin',               :to => 'sessions#new'

  match '/signout', :to => 'sessions#destroy'

  match '/partners/:id/waiting_approval', :to => 'partners#waiting_approval'
  match '/waiting_approval', :to => 'partners#waiting_approval'

  match '/partners/:id/dashboard', :to => 'partners#dashboard'
  match '/parceiros', :to => 'partners#dashboard'

  match '/cupons/nasp', :to => 'cupons#receive_key'

  match '/explore', :to => 'offers#explore'

  match "facebook/login" => "facebook_oauth#login"

  match "facebook/terminate" => "facebook_oauth#terminate"

  match 'profile', :to => 'users#profile'

  #Parte de Fale Conosco
  #Autor: Paulo Henrique
  match 'fale-conosco' => 'contact#new', :as => 'contact', :via => :get
  match 'fale-conosco' => 'contact#create', :as => 'contact', :via => :post

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'sessions#splash'
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

  #Redirecionamento para 404
  match '*a', :to => 'static#error'
end
