class Order < ApplicationRecord
  belongs_to :user
  has_one :cart ,dependent: :destroy
  has_many :line_items  
  validates :name,:email,:address, presence:true
  validates :number ,presence:true,:numericality => true,
                 :length => { :minimum => 10, :maximum => 13 }

  def Order.payment(params,order,url)
  @lineitems=LineItem.where(cart_id:params[:order][:cart_id])
    Stripe::Checkout::Session.create({
                                                 payment_method_types: ['card'],
                                                 metadata: { cart_id: params[:order][:cart_id],order_id:order},
                                                 line_items: line_items_list,
                                                 mode: 'payment',
                                                 # These placeholder URLs will be replaced in a following step.
                                                 success_url: "#{url}/user/order_place?session_id={CHECKOUT_SESSION_ID}",
                                                 cancel_url: "#{url}/user/cancel_payment"
                                                 })
  end

  private
  
  def Order.line_items_list
   @lineitems.map do |lineitem|
    {
     price_data: {
       currency: 'inr',
       product_data: {
        name: lineitem.product.name,
      },
       unit_amount: (lineitem.price * 100).to_i
     },
     quantity: lineitem.quantity
    }
   end
  end

end
