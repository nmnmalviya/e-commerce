class Admin::CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin
  before_action :set_category, except: %i[index create new create_subcategory]

  def index
    @categorys = Category.all
    @category =  Category.new
  end

  def show
    @subcategory = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_category_path(@category)
    else
      @categorys = Category.all
      render :index
    end
  end

  def create_subcategory
    @subcategory = Category.new(category_params)
    if @subcategory.save
      redirect_to request.referrer
    else
      redirect_to request.referrer, { notice: @subcategory.errors.full_messages[0] }
    end
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_categories_path
  end

  private

  def category_params
    params.require(:category).permit(:category_name, :parent_id)
  end

  def set_category
    @category = Category.find(params[:id])
  end

  def authorize_admin
    redirect_to root_path unless current_user.has_role?(:admin)
  end
end
