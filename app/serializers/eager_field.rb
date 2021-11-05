module Hypermedia
  def link_for(property, opts={})
    self.to_hash(opts)['links'].find { |link| link['rel'] == property.to_s }.try(:[], 'href')
  end

  def self.eager_fields(fields = nil)
    @eager_fields ||= []
    fields.nil? ? @eager_fields : @eager_fields.concat(fields).uniq!
  end

  def self.default_eager_fields(fields = nil)
    # binding.pry
    @default_eager_fields ||= []
    fields.nil? ? @default_eager_fields : @default_eager_fields.concat(fields).uniq!
  end
end
