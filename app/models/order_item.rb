class OrderItem < ApplicationRecord
  enum making_status: {
    not_created: 0,
    waiting_production: 1,
    in_production: 2,
    completed: 3
  }
  
  belongs_to :order
  belongs_to :item
  
  def subtotal
    item.with_tax_price * amount
  end
end
