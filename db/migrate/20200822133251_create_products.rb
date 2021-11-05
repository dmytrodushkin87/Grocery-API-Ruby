class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.references :sub_category, foreign_key: true
      t.string :name
      t.integer :quantity
      t.decimal :price, precision: 11, scale: 8
      t.decimal :discount, precision: 11, scale: 8
      t.boolean :availability, default: true
      t.datetime :deleted_at
      t.string :photo_url
      t.string :unit
      t.string :discount_kind
      t.decimal :tax_rate, precision: 11, scale: 8
      t.string :description, text:true
      t.timestamps
    end
  end
end
