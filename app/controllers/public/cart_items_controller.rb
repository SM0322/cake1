class Public::CartItemsController < ApplicationController
  def index
    @cart_items = current_customer.cart_items.all
    @total = @cart_items.inject(0) {|sum, cart_item| sum + cart_item.subtotal}
  end
  
  def create
    @cart_item = CartItem.new(cart_item_params)
    @cart_item.customer_id = current_customer.id
    @cart_item.save
    redirect_to cart_items_path
  end
  
  def destroy
    @cart_item = current_customer.cart_items.find(params[:id])
    @cart_item.destroy
    redirect_to request.referer
  end

  def destroy_all
    @cart_items = current_customer.cart_items.all
    @cart_items.destroy_all
    redirect_to cart_items_path
  end
  
  private
    def set_cart_item
      @cart_item = current_customer.cart_items.find(params[:id])
    end

    def cart_item_params
      params.permit(:item_id, :amount)
    end
    
    def increase_or_create(item_id, amount)
      cart_item = current_customer.cart_items.find_by(item_id: item_id)
      if cart_item
        cart_item.update(amount: cart_item.amount + amount.to_i)
      else
         current_customer.cart_items.new(cart_params).save
      end
    end


end
