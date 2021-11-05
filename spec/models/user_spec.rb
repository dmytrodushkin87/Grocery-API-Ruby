require 'rails_helper'

# Test suite for User model
RSpec.describe User, type: :model do
  # Association test
  # ensure User model has a 1:m relationship with the Todo model
  # Validation tests
  # ensure name, email and password_digest are present before save
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:mobile_number) }
  it { should validate_presence_of(:password_digest) }
  it { should validate_uniqueness_of(:mobile_number) }
end