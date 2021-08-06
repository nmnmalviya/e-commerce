class User::CartsController < ApplicationController

  def index
    if user_signed_in?
      @carts = current_user.carts.unorderd
    else
      @products = session[:cart] ? session[:cart].keys.map { |id| Product.find(id) } : []
      @cart = session[:cart]
    end
  end

  def show
    @cart = Cart.find(params[:id])
  end

  def add_to_cart
    @product = Product.find(params[:id])
    if user_signed_in?
      user_cart
    else
      session_cart
    end
  end

  def remove_from_cart
    if user_signed_in?
      @cart_product = LineItem.where(cart_id: params[:cart], product_id: params[:product]).first
      @cart_product_id = @cart_product.id
      @cart_product.delete
    else
      @product_detail = session[:cart][params[:product]]
      session[:cart].delete(params[:product])
    end
    respond_to do |format|
      format.js
    end
  end

  def add_quantity
    if user_signed_in?
      @cart = Cart.find(params[:cart_id])
      @lineitem = LineItem.find(params[:id])
      @previous_quantity = @lineitem.quantity
      @lineitem.update!(quantity: params['quantity' + params[:id]])
    else
      @previous_quantity = session[:cart][params[:product_id]].clone
      session[:cart][params[:product_id]]['quantity'] = params['quantity' + params[:product_id]].to_i
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    if user_signed_in?
      @cart = Cart.find(params[:id])
      @cart.destroy
    else
      session.delete(:cart)
    end
    redirect_to request.referer
  end

  private

  def user_cart
    @cart = current_user.carts.find_or_create_by!(status: 'unorderd')
    if @lineitem = LineItem.where(product_id: @product.id, cart_id: @cart.id).first
      @lineitem.quantity += 1
    else
      @lineitem = LineItem.new(cart_id: @cart.id, quantity: 1, price: @product.price.to_f, product_id: @product.id)
    end
    if @lineitem.save
      redirect_to user_carts_path
    else
      redirect_to root_path
    end
  end

  def session_cart
    if session[:cart].is_a?(Hash)
      if session[:cart].include?(@product.id.to_s)
        session[:cart][@product.id.to_s]['quantity'] += 1
      else
        session[:cart][@product.id.to_s] = { price: @product.price, quantity: 1 }
      end
    else
      session[:cart] = {}
      session[:cart][@product.id.to_s] = { price: @product.price, quantity: 1 }
    end
    redirect_to user_carts_path
  end
end
