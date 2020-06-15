module ApplicationHelper
  def format_price(price)
    return "$ %.2f" % price
  end
end
