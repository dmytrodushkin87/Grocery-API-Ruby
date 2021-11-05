class OrderPolicy < ApplicationPolicy
  def read?
    user === record.cart.user
  end

  def create?
    user === record.cart.user
  end

  def update?
    user === record.cart.user
  end

  def destroy?
    user === record.cart.user
  end
end
