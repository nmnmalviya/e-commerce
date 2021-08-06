class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    if session[:cart]
      @cart = resource.carts.find_or_create_by!(status: 'unorderd')
      session[:cart].each do |key, value|
        if @lineitem = LineItem.where(product_id: key, cart_id: @cart.id).first
          @lineitem.quantity += 1
          @lineitem.save
        else
          @lineitem = LineItem.create(cart_id: @cart.id, quantity: value['quantity'].to_i, price: value['price'].to_f,product_id: key)
        end
      end
      session.delete(:cart)
    end

    if resource.has_role?(:admin)
      admin_users_url
    elsif resource.has_role?(:supplier)
      supplier_categories_url
    else
      home_products_path
    end
  end
end
