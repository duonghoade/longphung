require 'csv'
namespace :longphung do
  task create: :environment do
    GiftCode.delete_all
    Customer.delete_all
    department = ""
    CSV.foreach("#{Rails.root}/backup/longphung.csv").with_index(1) do |row, i|
      department = row[0].nil? ? row[1] : department
      unless row[0].nil?
        name = row[1].upcase + "<br/>PHÒNG #{department.upcase}"
        customer = Customer.create(
          name: name
        )
        customer.gift_codes.create(code: i)
      end
    end
  end

end
