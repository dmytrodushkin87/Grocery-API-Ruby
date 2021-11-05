class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.datetime :deleted_at
      t.string :photo_url
      t.timestamps
    end
  end
end
