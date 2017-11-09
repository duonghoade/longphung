class CreateGiftCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :gift_codes do |t|
      t.integer :code
      t.references :customer, foreign_key: true

      t.timestamps
    end
  end
end
