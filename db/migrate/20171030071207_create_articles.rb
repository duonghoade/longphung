class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :url_slug
      t.integer :article_type
      t.string :source
      t.integer :publish, default: 0
      t.string :thumbnail
      t.integer :first_macth_id

      t.timestamps
    end
  end
end
