class CreateCarts < ActiveRecord::Migration[5.0]
  def change
    create_table :carts do |t|
      t.references :offer, foreign_key: true
      t.references :user, foreign_key: true
      t.string :mode_of_payment
      t.string :status
      t.string :addres_line_1
      t.string :addres_line_2
      t.string :city
      t.string :postal_code
      t.string :state
      t.string :delivery_place
      t.string :mobile_number
      t.datetime :unconfirmed_at
      t.datetime :pending_at
      t.datetime :approved_at
      t.datetime :confirmed_at
      t.datetime :cancelled_at
      t.datetime :delivered_at
      t.string :delivery_person_name
      t.string :delivery_person_mobile_number
      t.timestamps
    end
  end
end
