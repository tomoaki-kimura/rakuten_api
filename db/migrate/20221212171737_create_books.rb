class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.string :isbn, null: false
      t.string :title, null: false
      t.string :author
      t.string :item_price
      t.string :item_url
      t.string :image_url

      t.timestamps
      t.index [:isbn]
      t.index [:title]
    end
  end
end
