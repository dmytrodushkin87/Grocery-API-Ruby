require_relative 'collection_builder'
class DatasetBuilder < CollectionBuilder
  private

  def get_page
    @page ||= get_eager_dataset
      .limit(get_limit)
      .offset(get_offset)
      .all
  end

  def get_eager_dataset
    eager_dataset = if values[:expand].blank?
      get_dataset
    else
      dataset = get_dataset
      # values[:expand].split(",").map(&:to_sym).each do |requested_field|
        # values[:representer].eager_fields.each do |eager_field|
        #   case eager_field
        #   when Symbol
        #     dataset = dataset.eager(eager_field) if eager_field == requested_field
        #   when Hash
        #     eager_field.each do |k, v|
        #       if v.is_a?(Symbol)
        #         dataset = dataset.eager(v) if k == requested_field
        #       elsif v.is_a?(Proc)
        #         dataset = dataset.select_append(&v) if k == requested_field
        #       end
        #     end
        #   end
        # end
        # binding.pry
        # dataset = dataset.eager_load(requested_field)
        # binding.pry
      # end
      dataset
    end
    eager_dataset
  end

  def total
    @total ||= get_dataset.count
  end

  def get_dataset
    @dataset ||= values[:order].inject(get_filtered_model.where.not(get_exclusions)) do |ds, (column, order)|
      if ['asc', 'desc'].include?(order)
        ds.order(column.to_sym => order.to_sym)
      end
    end
  end

  def get_filtered_model
    @filtered_model ||= model.respond_to?(:filters) ? model.filters(values[:filters]) : model
  end

  def get_exclusions
    @exclusions ||= values[:exclude]
      .tap { |exclude| exclude.merge!(model.send(:model).qualified_primary_key_hash(exclude.delete(:id))) if exclude[:id] }
  end

  def get_model_name
    @model_name ||= model.send(:model).name
  end

  def get_aggregations
    return nil if !get_dataset.respond_to?(:aggregations, false) || values[:options][:aggregations].nil?
    @aggregations ||= (
      buckets = get_dataset.aggregations(values[:options][:aggregations]).map do |object|
        OpenStruct.new(name: object[values[:options][:aggregations].to_sym], count: object[:count])
      end
      Array(OpenStruct.new(field: values[:options][:aggregations], buckets: buckets))
    )
  end
end
