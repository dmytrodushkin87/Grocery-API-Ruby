class CartPolicy < ApplicationPolicy
  def read?
    user === record.user
  end

  def create?
    user === record.user
  end

  def update?
    user === record.user
  end

  def destroy?
    user === record.user
  end
end
