class AddHighLightToArticle < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :high_light, :boolean, after: :sort_no, default: false
  end
end
