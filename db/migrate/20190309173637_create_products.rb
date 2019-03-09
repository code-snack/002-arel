class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.string :sku
      t.float :price
      t.boolean :active
      t.belongs_to :category, foreign_key: true

      t.timestamps
    end
  end
end
