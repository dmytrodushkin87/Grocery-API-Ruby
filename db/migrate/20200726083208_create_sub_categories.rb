class CreateSubCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :sub_categories do |t|
      t.string :name
      t.datetime :deleted_at
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
