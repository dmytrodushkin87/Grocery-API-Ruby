class UserPolicy < ApplicationPolicy
  def read?
    user === record
  end

  def create?
    user === record
  end
end
