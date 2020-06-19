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

  
  def flash_class(level)
    case level
      when 'notice' then "alert alert-notice"
      when 'success' then "alert alert-success"
      when 'error' then "alert alert-error"
      when 'warning' then "alert alert-warning"
    end
  end
end
