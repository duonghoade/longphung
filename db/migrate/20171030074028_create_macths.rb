class CreateMacths < ActiveRecord::Migration[5.1]
  def change
    create_table :macths do |t|
      t.string :title
      t.string :youtube_url
      t.references :macthable, polymorphic: true
      t.integer :sort_no, default: 0

      t.timestamps
    end
  end
end
