ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :first_name, :last_name, :email, :password_digest, :address_line_1, :address_line_2, :latitude, :longitude, :city, :province, :postal_code, :country, :photo_url, :mobile_number, :date_of_birth, :new_email, :new_mobile_number, :whatsapp_mobile_number
  #
  # or
  #
  # permit_params do
  #   permitted = [:first_name, :last_name, :email, :password_digest, :address_line_1, :address_line_2, :latitude, :longitude, :city, :province, :postal_code, :country, :photo_url, :mobile_number, :date_of_birth, :new_email, :new_mobile_number, :whatsapp_mobile_number]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
