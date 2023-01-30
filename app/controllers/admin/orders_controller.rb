class Admin::OrdersController < ApplicationController
  def show
    @order = Order.find(params[:id])
    @order_item = @order.order_items
    @total = @order_item.inject(0) {|sum, cart_item| sum + cart_item.subtotal}
  end

  def update
      @order = Order.find(params[:id])
      @order.update(order_params)
   if @order.status == "payment_confirmation"                      #もし入金確認に更新されたら
      @order_item = @order.order_items                             #orderに紐づく商品すべてを
      @order_item.update_all(making_status:'waiting_production')   #製作待ちに変更する
   end
      redirect_back(fallback_location: admin_order_path)
  end
  
  private

  def order_params
    params.require(:order).permit(:status, :order_item)
  end
end
