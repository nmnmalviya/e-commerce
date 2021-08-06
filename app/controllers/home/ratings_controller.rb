class Home::RatingsController < ApplicationController
  before_action :authenticate_user!, except: %i[new edit]

  def index

  end

  def edit
    @rating = Rating.find(params[:id])
    @product = Product.find(params[:product_id])
  end

  def update
    @rating = Rating.find(params[:id])
    if @rating.update(rating: params[:rating])
      redirect_to root_path
    else
      render :edit
    end
  end

  def new
    @rating = Rating.new
    @product = Product.find(params[:id])
  end

  def create
    @rating = Rating.new(product_id: params[:product_id], user_id: current_user.id, rating: params[:rating])
    if @rating.save
      redirect_to root_path
    else
      render :new
    end
  end

  def create_review
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    if @review.save
      redirect_to request.referer
    else
      render :new
    end
  end

  private

  def review_params
    params.require(:review).permit(:name, :body, :product_id)
  end
end
