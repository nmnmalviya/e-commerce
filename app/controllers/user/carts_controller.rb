class User::CartsController < ApplicationController

	def index
		byebug
		if user_signed_in?
			@carts=current_user.carts
		else
			@products = session[:cart] ? session[:cart].keys.map { |id| Product.find(id) }:[]
			@cart=session[:cart]
		end
	end

	def show
		@cart=Cart.find(params[:id])
	end

	def add_to_cart
		@product=Product.find(params[:id])
		if user_signed_in?
			@cart=current_user.carts.find_or_create_by!(status: 'unorderd')
			if @lineitem=LineItem.where(product_id:@product.id,cart_id:@cart.id).first
				@lineitem.quantity+=1
			else
				@lineitem=LineItem.new(cart_id:@cart.id,quantity:1,price:@product.price.to_f,product_id:@product.id)
			end
				if @lineitem.save
					redirect_to user_carts_path
				else
					redirect_to root_path
				end
		else
			if session[:cart].is_a?(Hash)
				if session[:cart].include?(@product.id.to_s)
			 		session[:cart][@product.id.to_s]["quantity"]+=1
				else
			 		session[:cart][@product.id.to_s]={price:@product.price,quantity:1}
				end
			else
				session[:cart]={}
				session[:cart][@product.id.to_s]={price:@product.price,quantity:1}
			end
			 	redirect_to user_carts_path
		end
	end

	def remove_from_cart
		if user_signed_in?
			@cart_product=LineItem.where(cart_id: params[:cart],product_id: params[:product]).first
			@cart_product.delete
		else
			session[:cart].delete(params[:product])
		end
		redirect_to request.referrer
	end

	def add_quantity
		if user_signed_in?
			@lineitem=LineItem.find(params[:line_item][:id])
			@lineitem.update!(quantity:params[:line_item][:quantity])
		else
			session[:cart][params[:product_id]]["quantity"]=params[:quantity]
		end
		redirect_to request.referrer
	end

end