ActiveAdmin.register Cart do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :offer_id, :user_id, :mode_of_payment, :status, :addres_line_1, :addres_line_2, :city, :postal_code, :state, :delivery_place, :mobile_number, :unconfirmed_at, :pending_at, :approved_at, :confirmed_at, :cancelled_at, :delivered_at, :delivery_person_name, :delivery_person_mobile_number
  #
  # or
  #
  # permit_params do
  #   permitted = [:offer_id, :user_id, :mode_of_payment, :status, :addres_line_1, :addres_line_2, :city, :postal_code, :state, :delivery_place, :mobile_number, :unconfirmed_at, :pending_at, :approved_at, :confirmed_at, :cancelled_at, :delivered_at, :delivery_person_name, :delivery_person_mobile_number]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
