module ApplicationHelper

  # ￥priceで表示する
  def to_total_currency(price)
    number_to_currency(price, unit:'￥', strip_insignificant_zeros: true)
  end
  
end
