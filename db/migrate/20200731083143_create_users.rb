class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.string :address_line_1
      t.string :address_line_2
      t.decimal :latitude, precision: 11, scale: 8
      t.decimal :longitude, precision: 11, scale:8
      t.string :city
      t.string :province
      t.string :postal_code
      t.string :country
      t.string :photo_url
      t.string :mobile_number
      t.datetime :date_of_birth
      t.string :new_email
      t.string :new_mobile_number
      t.string :whatsapp_mobile_number
      t.timestamps
    end
  end
end
