class Public::OrdersController < ApplicationController
  def new
    @order = Order.new
    @deliveries = current_customer.deliveries
  end

  def confirm
    @cart_items = current_customer.cart_items.all
    @total = @cart_items.inject(0) {|sum, cart_item| sum + cart_item.subtotal}
    @order = current_customer.orders.new(order_params)
    @order.postage = 800
    select_destination(params[:order][:option])
  end
  
  def create
    order = current_customer.orders.new(order_params)
    order.status = 0
    order.save
    current_customer.cart_items.each do |cart_item|
      OrderItem.create(
        order_id: order.id,
        item_id: cart_item.item_id,
        price: cart_item.item.price,
        amount: cart_item.amount,
        making_status: 0
      )
    end
    current_customer.cart_items.destroy_all
    redirect_to complete_path
  end

  def complete
  end

  def index
    @orders = current_customer.orders
  end

  def show
    @order = current_customer.orders.find(params[:id])
  end
  
  private
    def order_params
      params.require(:order).permit(
        :post_code,
        :address,
        :name,
        :postage,
        :total_payment,
        :payment_method
        )
    end
    def select_destination(option)
      case option
        when '0'
          @order.post_code = current_customer.post_code
          @order.address = current_customer.address
          @order.name = current_customer.last_name
        when '1'
          delivry = Delivery.find(params[:order][:delivery_id])
          @order.post_code = delivery.post_code
          @order.address = delivery.address
          @order.name = delivery.name
        when '2'
          @order.post_code = params[:order][:other_post_code]
          @order.address = params[:order][:other_address]
          @order.name = params[:order][:other_name]
      end
    end
end
