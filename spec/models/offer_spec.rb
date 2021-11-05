require 'rails_helper'

RSpec.describe Offer, type: :model do
  it { should validate_presence_of(:code) }
end
