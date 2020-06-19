module MerchantsHelper
  def render_merchant_orders(merchant, orders)
    render partial: "orders", locals: { merchant: merchant, variable: orders }
  end

end
