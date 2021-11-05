module Payloadable
  [:dataset, :array, :search, :multi_search].map do |type|
    define_method("#{type}_payload") do |model, representer, options = {}|
      collection_payload(model, representer, options.merge(builder: :"#{type.to_s.classify}Builder"))
    end
  end

  def payload(model, representer, options = {})
    case model
    when ActiveRecord::Relation
      dataset_payload(model, representer, options)
    when Array
      array_payload(model, representer, options)
    else
      object_payload(model, representer, options)
    end
  end

  def collection_payload(model, representer, options = {})
    builder_class = "#{options[:builder] || :CollectionBuilder}".constantize
    builder = collection_of(builder_class, model, representer, options)
    json_response(PayloadSerializer.new(builder.build).to_hash, options[:status])
  end

  def object_payload(model, representer, options = {})
    builder = object_of(ObjectBuilder, model, representer, options)
    json_response(PayloadSerializer.new(builder.build).to_hash, options[:status])
  end

  private

  def collection_of(builder_class, model, representer, options)
    builder_class.new do |builder|
      builder.model = model
      builder.representer = representer
      builder.options = options
      builder.page_size = @page_size
      builder.page_no = @page_no
      builder.filters = @filter
      builder.order = @order
      builder.path_info = request.path_info
      builder.pagination = @pagination
      builder.exclude = @exclude
      builder.expand = @expand
      builder.query_hash = @query_hash if builder.respond_to?(:query_hash=)
      builder.models = options[:models] if builder.respond_to?(:models=)
    end
  end

  def object_of(builder_class, model, representer, options)
    builder_class.new do |builder|
      builder.model = model
      builder.representer = representer
      builder.options = options
      builder.path_info = request.path_info
      builder.expand = @expand
    end
  end
end
