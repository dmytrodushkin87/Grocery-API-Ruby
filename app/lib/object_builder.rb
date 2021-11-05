class ObjectBuilder
  [:model, :representer, :options, :expand, :path_info].each do |method_name|
    define_method "#{method_name}=" do |value|
      @values[method_name] = value
    end
  end

  def initialize
    @values = {}
    yield(self) if block_given?
  end

  attr_reader :values

  def model
    @model ||= values[:model]
  end

  def build
    Payload.new(
      data: get_data,
      errors: get_errors,
      path_info: values[:path_info],
      type: get_type,
      retrieved_at: retrieved_at
    )
  end

  private

  def get_data
    # binding.pry
    model&.expand = values[:expand]
    values[:representer].new(model).to_hash
    # @data ||= values[:representer]
    #   .prepare(model)
    #   .to_hash(values[:options].merge(expand: values[:expand])) if model.errors.empty?
  end

  def retrieved_at
    @retrieved_at ||= model.values[:retrieved_at] if model.respond_to?(:db_schema)
  end

  def get_errors
    @errors ||= model.errors if !model.errors.empty?
  end

  def get_type
    @type ||= values[:options][:type] || model.class.name
  end
end
