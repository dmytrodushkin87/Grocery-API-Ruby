module Expandable
  def expands?(property)
    lambda { |opts| opts[:expand] && opts[:expand].split(',').include?(property) }
  end
end
