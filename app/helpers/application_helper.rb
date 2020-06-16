module ApplicationHelper
  def format_price(price)
    return "$ %.2f" % price
  end
  def show_active_action(product)
    if product.active
      return "Deactivate"
    else
      return "Re-activate"
    end
  end
end
