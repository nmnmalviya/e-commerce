class User::ProductsController < ApplicationController
  def index
    redirect_to root_path
  end

  def show
    @category = Category.find(params[:id])
  end
end
