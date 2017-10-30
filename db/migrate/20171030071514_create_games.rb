class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.string :name
      t.integer :c_num
      t.references :article, foreign_key: true

      t.timestamps
    end
  end
end
