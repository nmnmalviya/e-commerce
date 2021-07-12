class Supplier::CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_supplier
  before_action :get_category, except: %i[index create new]

  def index
    @categorys = Category.all
  end

  def show
    @subcategory = Category.new
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      if @category.parent_id.present?
        redirect_to request.referrer
      else
        redirect_to @category
      end
    else
      render :new
    end
  end

  def edit; end

  def update
    if @category.update(category_params)
      redirect_to @category
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_path
  end

  private

  def category_params
    params.require(:category).permit(:category_name, :parent_id)
  end

  def get_category
    @category = Category.find(params[:id])
  end

  def authorize_supplier
    redirect_to root_path unless current_user.has_role?(:supplier)
  end
end
