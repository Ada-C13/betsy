module ApplicationHelper

  def format_currency(price)
    format('$%<price>.2f', price: price)
  end

  def format_datetime(date)
    date.strftime("%B %e, %Y, %l:%M %P")
  end 
  
end
