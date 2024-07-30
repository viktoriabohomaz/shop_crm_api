class CustomerPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.present?
  end

  def create?
    user.present?
  end

  def update?
    tuser.present?
  end

  def destroy?
    user.present?
  end
end
