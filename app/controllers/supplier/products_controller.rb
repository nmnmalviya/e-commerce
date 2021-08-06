class Supplier::ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_supplier
  before_action :set_product, except: %i[index create]

  def index
    @products = current_user.products.page(params[:page]).per(6)
  end

  def show; end

  def new
    @product = Product.new
  end

  def create
    @category = Category.find(params[:product][:category_id])
    @product = @category.products.new(product_params)
    @product.user_id = current_user.id
    if @product.save
      redirect_to supplier_product_path(@product), flash: { notice: 'product Add succesfull' }
    else
      render :new
    end
  end

  def edit; end

  def update
    if @product.update(product_params)
      redirect_to supplier_product_path(@product), flash: { notice: 'Updated succesfull' }
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to supplier_products_path
  end

  def add_stock
    @product.update(stock: params[:stock])
    redirect_to request.referrer, flash: { notice: 'Stock Added succesfull' }
  end

  private

  def product_params
    params.require(:product).permit(:picture, :category_name, :name, :about, :price, :stock)
  end

  def authorize_supplier
    redirect_to root_path unless current_user.has_role?(:supplier)
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
