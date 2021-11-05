class CollectionBuilder
  def initialize
    @values = {}
    yield(self) if block_given?
  end

  attr_reader :values

  def model
    @model ||= values[:model]
  end

  [:model, :representer, :options, :page_size, :page_no, :filters, :order,
  :path_info, :pagination, :exclude, :expand].each do |method_name|
    define_method "#{method_name}=" do |value|
      @values[method_name] = value
    end
  end

  def aggregations
    if self.respond_to?(:get_aggregations, true)
      get_aggregations
    end
  end

  def inner_hits
    if self.respond_to?(:get_inner_hits, true)
      get_inner_hits
    end
  end

  def build
    # binding.pry
    a = Payload.new(
      data: data,
      path_info: values[:path_info],
      total: total,
      page_size: page_size,
      page_no: page_number,
      previous_page: previous_page_number,
      next_page: next_page_number,
      last_page_no: last_page_number,
      type: values[:options][:type] || get_model_name,
      aggregations: aggregations,
      retrieved_at: retrieved_at
    )
    # binding.pry
  end

  private

  def data
    JSON.parse(
      ActiveModel::Serializer::CollectionSerializer.new(
        get_page.each {|t| t.expand = values[:expand]},
        serializer: values[:representer]
      ).to_json
    )
    # get_page
    # values[:representer]
    #   .for_collection
    #   .prepare(get_page)
    #   .to_hash(values[:options].merge(expand: values[:expand], inner_hits: inner_hits))
  end

  def retrieved_at
    return nil if  get_page.count == 0 || !get_page.first.class.respond_to?(:db_schema)
    @retrieved_at ||= get_page.first.values[:retrieved_at]
  end

  def get_limit
    @limit ||= (page_size > 0 ? page_size : nil)
  end

  def get_offset
    @offset ||= (page_number - 1) * page_size
  end

  def page_size
    if paginated?
      values[:page_size] && values[:page_size].to_i > 0 ? [values[:page_size].to_i, max_page_size].min : max_page_size
    else
      total
    end
  end

  def max_page_size
    @max_page_size ||= Settings.payload_max_size
  end

  def page_number
    @actual_page_no ||= if paginated?
      values[:page_no] && values[:page_no].to_i > 0 ? values[:page_no].to_i : 1
    else
      1
    end
  end

  def previous_page_number
    @previous_page ||= [page_number - 1, 1].max
  end

  def next_page_number
    @next_page ||= [page_number + 1, last_page_number].min
  end

  def last_page_number
    @last_page_no ||= if paginated? && total != 0
      (total / page_size) + (total % page_size == 0 ? 0 : 1)
    else
      1
    end
  end

  def paginated?
    true
    # @paginated ||= !$settings.unpaginated_models.include?(get_model_name.to_sym) || values[:pagination]
  end
end
