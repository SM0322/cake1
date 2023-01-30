class Admin::OrderItemsController < ApplicationController
  def update
    @order_item = OrderItem.find_by(id: params[:id])                             #ボタンが押されたらそのidの注文商品を探す
    @order = @order_item.order                                                   #その商品を含んでいる注文を探す
    @order_items = @order.order_items.all                                        #その注文内の商品すべてを探す
    
    is_updated = true                                                            #is_updatedという変数をtrueとする
    if  @order_item.update(orderitem_params)                                     #注文商品の変更を保存したら
        @order.update(status: 2) if @order_item.making_status == "in_production" #製作ステータスを2の製作中に変更する
        @order_items.each do |order_item|                                        #紐付いている注文商品の製作ステータスを一つ一つeach文で確認して
         if order_item.making_status != "completed"                              #製作ステータスが「製作完了」ではない場合 
         is_updated = false                                                      #上記で定義してあるis_updatedを「false」に変更する。
        end
    end
    
    @order.update(status: 3) if is_updated                                       #is_updatedがすべてtrueになったら注文のステータスを発送準備中に変更する
    end
        redirect_back(fallback_location: admin_order_path)
    end
    
  private

  def orderitem_params
    params.require(:order_item).permit(:order_item, :order, :making_status)
  end
end
