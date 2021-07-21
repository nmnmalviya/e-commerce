class Supplier::ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_supplier

  def index
    @products=current_user.products.page(params[:page]).per(6)
  end

  def show
    @product=Product.find(params[:id])
  end

  def new
    @category=Category.find(params[:id])
    @product=Product.new
  end

  def create
    @category=Category.find(params[:product][:category_id])
    @product=@category.products.new(product_params)
    @product.user_id=current_user.id
    if @product.save
      redirect_to supplier_product_path(@product)
    else
      render :new
    end
  end

  def edit
    @product=Product.find(params[:id])
  end

  def update
      @product=Product.find(params[:id])
      if @product.update(product_params)
      redirect_to supplier_product_path(@product)
    else
      render :edit
    end
  end 

  def destroy
    @product=Product.find(params[:id])
    @product.destroy
    redirect_to supplier_products_path
  end

  private
    def product_params
      params.require(:product).permit(:picture,:category_name,:name,:about,:price)
    end

    def authorize_supplier
    redirect_to root_path unless current_user.has_role?(:supplier)
    end
end
