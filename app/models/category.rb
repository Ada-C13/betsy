class Category < ApplicationRecord
  has_and_belongs_to_many :products



  protected 

  def self.category_options
    [["Quarantine", "Quarantine"], 
      ["Protest", "protest"], 
      ["Covid 19", "Covid 19"], 
      ["Work From Home", "Work From Home"], 
      ["Murder Hornets", "Murder hornets"], 
      ["Election", "Election"], 
      ["Pass the Time", "Pass the time"], 
      ["Donate", "Donate"], 
      ["Essentials",'Essentials' ], 
      ["Almost War", 'Almost War'], 
      ['Space Mission', 'Space Mission'], 
      ['Stock Market Fall', 'Stock Market Fall'], 
      ['Impeachment', 'Impeachment'], 
      ['Brexit','Brexit'], 
      ['RIP Kobe', 'RIP Kobe'], 
      ['Events Cancelations', 'Events Cancelations']]
  end 
end
