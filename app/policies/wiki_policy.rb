class WikiPolicy < ApplicationPolicy
  attr_reader :user, :wiki

  def initialize(user, wiki)
    @user = user
    @wiki = wiki
  end

  def update?
    if wiki.private == true
      user.admin? || wiki.user == user || wiki.users.include?(user)
    else
      user.present?
    end
  end

  def new?
    user.present?
  end

  def create?
    user.present?
  end

  def show?
    user.present?
  end

  def edit?
    user.present?
  end

  def destroy?
    user.admin?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.present? && user.role == 'admin'
        scope.all
      elsif user.present? && user.role == 'premium'
        scope.all.where('private = ? OR user_id = ?', false, user.id)
      else
        scope.all.where('private = ?', false)
      end
    end

  end
end
