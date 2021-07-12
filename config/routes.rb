Rails.application.routes.draw do

  namespace :user do
    resources :categories ,:products , :carts ,:orders
    get "add_to_cart[:id]" ,to: "carts#add_to_cart", as: 'add_to_cart'
    get "remove_from_cart" ,to: "carts#remove_from_cart", as: 'remove_from_cart'
    post "add_quantity_to_cart" ,to: "carts#add_quantity", as: 'add_quantity_to_cart'
    get "order_place", to: "orders#order_place", as: 'order_place'
    get "order_history", to: "orders#order_history", as: 'order_history'
    get "delete_order", to: "orders#delete_order" ,as: 'delete_order'
  end 
  
  resources :charges 

  namespace :admin do
    resources :users , :categories 
  end
 
  namespace :supplier do
    resources  :categories ,:products
  end



  devise_for :users , :controllers => {:registrations => "registrations"}

  root to: "homes#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
