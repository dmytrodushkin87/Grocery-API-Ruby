require_relative "eager_field"
class PayloadSerializer < ActiveModel::Serializer

  # include Hypermedia

  attributes :meta, :data

  def meta
    {
      total: total,
      page_size: page_size,
      page_no: page_no,
      type: type
    }
  end

  [:total, :page_size, :page_no, :type].map do |t|
    define_method("#{t}") do
      object.send(:"#{t}") rescue nil
    end
  end

  def data
    object.data
  end
  # property :data
  # property :errors, getter: lambda { |args| errors.with_detail if errors }

  # link :self do
  #   "#{$settings.base_url}#{represented.path_info}?page_size=#{represented.page_size}&page_no=#{represented.page_no}"
  # end

  # link :first_page do
  #   "#{$settings.base_url}#{represented.path_info}?page_size=#{represented.page_size}&page_no=1"
  # end

  # link :previous_page do
  #   "#{$settings.base_url}#{represented.path_info}?page_size=#{represented.page_size}&page_no=#{represented.previous_page}"
  # end

  # link :next_page do
  #   "#{$settings.base_url}#{represented.path_info}?page_size=#{represented.page_size}&page_no=#{represented.next_page}"
  # end

  # link :last_page do
  #   "#{$settings.base_url}#{represented.path_info}?page_size=#{represented.page_size}&page_no=#{represented.last_page_no}"
  # end
end
