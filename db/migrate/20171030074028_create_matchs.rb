class CreateMatchs < ActiveRecord::Migration[5.1]
  def change
    create_table :matches do |t|
      t.string :title
      t.string :youtube_url
      t.references :matchable, polymorphic: true
      t.integer :sort_no, default: 0

      t.timestamps
    end
  end
end
