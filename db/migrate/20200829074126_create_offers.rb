class CreateOffers < ActiveRecord::Migration[5.0]
  def change
    create_table :offers do |t|
      t.string :description
      t.string :title
      t.decimal :value, precision: 11, scale: 8
      t.decimal :max_value, precision: 11, scale: 8
      t.string :kind
      t.string :code
      t.datetime :starts_at
      t.datetime :finishes_at
      t.boolean :active, default: false
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
