Rails.application.routes.draw do

  namespace :user do
    resources :categories ,:products , :carts ,:orders
    get "add_to_cart/:id" ,to: "carts#add_to_cart", as: 'add_to_cart'
    delete "remove_from_cart" ,to: "carts#remove_from_cart"
    post "add_quantity", to: "carts#add_quantity"
    get "order_place", to: "orders#order_place", as: 'order_place'
    get "order_history", to: "orders#order_history", as: 'order_history'
    get "cancel_payment", to: "orders#cancel_payment" ,as: 'cancel_payment'
  end 

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
