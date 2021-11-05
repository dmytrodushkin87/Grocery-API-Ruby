class Payload
  attr_reader :data, :errors, :path_info, :total, :page_size,
              :page_no, :previous_page, :next_page, :last_page_no, :type, :aggregations, :retrieved_at

  def initialize(attributes)
    attributes.each do |(key, value)|
      instance_variable_set("@#{key}", value)
    end
  end
end
