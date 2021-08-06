class Home::ProductsController < ApplicationController
  def index
    redirect_to root_path
  end

  def show
    @products = Product.where(category_id: params[:id])
    @products = @products.page(params[:page]).per(6)
  end
end
