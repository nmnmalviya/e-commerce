  class User::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :get_order ,only: [:edit,:update]

  Stripe.api_key = 'sk_test_51J9oJASBnEsdstJlBPd81H1g5zqBHfScC8yix2SSUqPDzYTsTmP0IfDxlOJocQTYPgeh6jlPbfuVJGEkkeTUq4ie001Tnr610x'

  def index
    @orders = current_user.orders    
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
      @cart = Cart.find(params[:order][:cart_id]).update(order_id: @order.id)
      payment(params,@order.id)
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
    redirect_to user_order_path(@order)
  end


  def edit
    @cart=Cart.find(params[:cart_id])
    @total = params[:total]
  end

  def update
    byebug
    if @order.update(order_params)
      payment(params,@order.id)
    else
      render :edit
    end
  end

  private

  def order_params
    params.require(:order).permit(:name, :address, :email, :number, :total, :status)
  end

  def payment(params,order_id)
      session = Stripe::Checkout::Session.create({
                                                   payment_method_types: ['card'],
                                                   metadata: { cart_id: params[:order][:cart_id],order_id:order_id},
                                                   line_items: [{
                                                     price_data: {
                                                       currency: 'inr',
                                                       unit_amount: (params[:order][:total].to_f * 100).to_i
                                                     },
                                                     quantity: 1
                                                   }],
                                                   mode: 'payment',
                                                   # These placeholder URLs will be replaced in a following step.
                                                   success_url: "#{request.base_url}/user/order_place?session_id={CHECKOUT_SESSION_ID}",
                                                   cancel_url: "#{request.base_url}/user/delete_order?order_id=@order.id"
                                                   })
      redirect_to session.url, status: 303
  end

  def get_order
    @order=Order.find(params[:id])
  end

end


