class UpdateLanAnhName < ActiveRecord::Migration[5.1]
  def change
    Customer.find(413).update(name: "Chị Lan Anh EVN")
  end
end
