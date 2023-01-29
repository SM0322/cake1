class Public::ItemsController < ApplicationController
before_action :set_genres

  def index
   @items = Item.all
  end

  def show
   @item = Item.find(params[:id])
   @cart = CartItem.new
  end
  
  private
    def set_genres
      @genres = Genre.all
    end
    
    def item_params
      params.require(:item).permit(:name, :introduction, :price)
    end
end
