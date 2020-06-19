class Product < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :reviews
  has_and_belongs_to_many :categories

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def average_rating
    length = self.reviews.length

    return 0 if length == 0

    total_rating = self.reviews.sum { |review| review.rating }

    return (total_rating / length).round(1)
  end

  
  def self.spotlight(products)
    if !products.empty?
      return products.last
    end
  end

  def self.top_rated(products)
    if !products.empty?
      top_rated = products.sort_by { |product| product.average_rating}.reverse
      return top_rated[0..5]
    end
  end

  after_initialize :set_defaults

  def set_defaults
    self.product_status ||= "active"
    # self.photo_url ||= "https://lh3.googleusercontent.com/0hJSje8_Z034MV_zDnQFGVt1Id-P21tDb3AP-J7WFtH0ITgL47YvUV642kZg1fXxtZaO47A14pRjWP2tG-2AlHm7jst2i8mB-yZQPX0I67SB4X9iJs4Co9lge5RlgsMoK8BeP1pXNtKuQkneNuBrxPr-x6n2KpVj7tA_E4k1krdZPj6Z_kZT8XzNIN_ztY3rD9HdwInpgaQ7HYImlTdGo_A50RoLEJ-7sK2_gFJAbSLIwnxEAAcaw7ELKxhO0p2QUbBk8Qwp3GnleViM2LVIUIQMcQDt7JvcKgPWH1DpNYpv8GRitVPOIBOt4mVvsVSJ5I6iBXU_7Tz1b1HQC97OajROBAWNSYryi_wqrac6MjfwFS0VbRxiAthPtUxApWpwTmxSF8LTqtUh2MQfLnOGp4wnX-CkfIQzqazG20xxXvsv24iLE1PZwjwkFb2vE8fglhUr0PAvEHseJz7D1PJwt5MtH38gdDPTK8o8WhJ1R4vGaiCqcekvR6OUGy4DYUEjW-zd3psZpwuQLxPLlgefvSvL4lErgVrxV8bg61cn7WcQ2Avev4L36DAS40RyY0cqInt_CJ-9Ovp3oRPTwTp0EwEL2XmHHKoW8yaSgJloyjAzWT9SHAAnoAoTjHWeHvXot8qdWvT8dwmq-LRsR_-cpE5-qNo2ejrkDUrCD5k7R35r5F_TKXLG9CX-Tkrf7g=w600-h512-no?authuser=0"
  end

  def decrease_inventory(quantity)
    self.stock -= quantity
  end
  
end
