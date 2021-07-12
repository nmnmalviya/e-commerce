class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)

    if session[:cart]
        @cart=resource.carts.find_or_create_by!(status: 'unorderd')
        session[:cart].each do |key,value|
          @lineitem=LineItem.create(cart_id:@cart.id,quantity:value["quantity"].to_f,price:value["price"].to_i,product_id:key)
        end
        session.delete(:cart)
    end

    if resource.has_role?(:admin)
      admin_users_url
    elsif resource.has_role?(:supplier)
      supplier_categories_url
    else
      user_products_path
    end
  end
end
