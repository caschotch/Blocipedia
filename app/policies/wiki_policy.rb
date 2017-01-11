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
      wikis = []
      if user.present? && user.role == 'admin'
        wikis = scope.all
      elsif user.present? && user.role == 'premium'
        all_wikis = scope.all
        all_wikis.each do |wiki|
          if !wiki.private? || wiki.user == user
            wikis << wiki
          end
        end
      else
        all_wikis = scope.all
        wikis = []
        all_wikis.each do |wiki|
          if !wiki.private?
            wikis << wiki
          end
        end
      end
      wikis
    end

  end

end
