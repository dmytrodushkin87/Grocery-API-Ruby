ActiveAdmin.register Offer do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :description, :title, :value, :max_value, :kind, :code, :starts_at, :finishes_at, :active, :deleted_at
  #
  # or
  #
  # permit_params do
  #   permitted = [:description, :title, :value, :max_value, :kind, :code, :starts_at, :finishes_at, :active, :deleted_at]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
