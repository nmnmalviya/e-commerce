class HomesController < ApplicationController
  def index
    @q=Product.ransack(params[:q])
    @products=@q.result.page(params[:page]).per(6)
  end

end

