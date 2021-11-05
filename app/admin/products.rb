ActiveAdmin.register Product do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :sub_category_id, :name, :quantity, :price, :discount, :availability, :deleted_at, :photo_url, :unit, :discount_kind, :tax_rate, :description
  #
  # or
  #
  # permit_params do
  #   permitted = [:sub_category_id, :name, :quantity, :price, :discount, :availability, :deleted_at, :photo_url, :unit, :discount_kind, :tax_rate, :description]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
