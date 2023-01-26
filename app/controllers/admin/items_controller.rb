class Admin::ItemsController < ApplicationController
  def new
    @item = Item.new
  end
  
  def create
    @item = Item.new(admin_params)
    if @item.save
      redirect_to admin_items_path
    else
      render :new
    end
  end
  
  def index
    @item = Item.all
  end

  def show
    @item = Item.find(params[:id])
    @genre = @item.genre
  end

  def edit
    @item = Item.find(params[:id])
  end
  
  def update
    @item = Item.find(params[:id])
    if @item.update(admin_params)
      redirect_to admin_item_path
    else
      render :edit
    end
  end
  
  private

  def admin_params
    params.require(:item).permit(:name, :introduction, :genre, :price, :is_active, :image, :genre_id)
  end
end
