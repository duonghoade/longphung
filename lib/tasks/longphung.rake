require 'csv'
namespace :longphung do
  task create: :environment do
    GiftCode.delete_all
    Customer.delete_all
    
    CSV.foreach("#{Rails.root}/backup/longphung.csv") do |row|
      name = row[0]
      phone = row[1].first.to_i == 0 ? row[1] : "0#{row[1]}"
      if Customer.find_by(phone: phone).present?
        customer = Customer.find_by(phone: phone)
      else
        customer = Customer.create(
          name: name,
          phone: phone
        )
      end
      row[2].split(",").each do |code|
        customer.gift_codes.create(code: code)
      end
    end
  end

end
