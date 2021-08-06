class User::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :get_order, only: %i[edit update destroy]

  Stripe.api_key = Rails.application.credentials.Stripe_api_key

  def index
    @orders = current_user.orders.page(params[:page]).per(6)
  end

  def new
    @total = params[:total]
    @cart = Cart.find(params[:cart_id])
    @order = Order.new
  end

  def show
    @order = Order.find(params[:id])
    @cart = @order.cart
  end

  def create
    @order = Order.new(order_params)
    @order.user_id = current_user.id
    if @order.save
      OrderMailer.with(user:@order.name,mail:@order.email).order_created.deliver_later
      @cart = Cart.find(params[:order][:cart_id]).update(order_id: @order.id)
      session = Order.payment(params, @order.id, request.base_url)
      redirect_to session.url, status: 303
    else
      @total = params[:order][:total]
      @cart = Cart.find(params[:order][:cart_id])
      render :new
    end
  end

  def order_place
    session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @cart = Cart.find(session.metadata.cart_id).update(status: 'ordered')
    @order = Order.find(session.metadata.order_id)
    @order.update!(status: params[:action], transection_id: session.payment_intent)
    redirect_to user_order_path(@order), flash: { notice: 'Order Placed ' }
  end

  def edit
    @cart = Cart.find(params[:cart_id])
    @total = params[:total]
  end

  def update
    if @order.update(order_params)
      OrderMailer.with(mail:@order.email,user:@order.name).order_created.deliver_later
      session = Order.payment(params, @order.id, request.base_url)
      redirect_to session.url, status: 303
    else
      render :edit
    end
  end

  def cancel_payment; end

  def destroy
    @order.destroy
    redirect_to request.referer
  end

  private

  def order_params
    params.require(:order).permit(:name, :address, :email, :number, :total, :status)
  end

  def get_order
    @order = Order.find(params[:id])
  end
end
