class OrderStatus
  def self.all 
    return ["paid", "complete", "canceled"]
  end 

  def self.optional_all
    return all.insert(0, "all")
  end 
end 