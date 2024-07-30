class UserPolicy < ApplicationPolicy
  def index?
    user.present? && user.is_admin?
  end

  def show?
    user.present? && user.is_admin?
  end

  def create?
    user.present? && user.is_admin?
  end

  def update?
    user.present? && user.is_admin? 
  end

  def destroy?
    user.present? && user.is_admin?
  end

  def change_admin_status?
    user.present? && user.is_admin?
  end
end
