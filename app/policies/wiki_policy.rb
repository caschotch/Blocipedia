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
        scope.joins('left join "collaborators" ON "collaborators"."wiki_id" = wikis.id').where('wikis.private = ? OR wikis.user_id = ? OR collaborators.user_id = ?', false, user.id, user.id)
      else
        scope.joins('left join "collaborators" ON "collaborators"."wiki_id" = wikis.id').where('wikis.private = ? OR collaborators.user_id = ?', false, user.id)
      end
    end

  end
end
#
# standard = Wiki.all.joins(:collaborators).where('private = ? OR user_id = ? OR collaborators.user_id = ?', false, user.id, user.id)
#
# [7] pry(main)> standard = Wiki.all.joins(:collaborators).where('private = ? OR user_id = ? OR collaborators.user_id = ?', false, user.id, user.id)
# NameError: undefined local variable or method `user' for main:Object
# from (pry):7:in `__pry__'
#
# [10] pry(main)> Wiki.joins(:collaborators).where('private = ? OR user_id = ? OR collaborators.user_id = ?', false, user.id, user.id)
#   Wiki Load (0.6ms)  SELECT "wikis".* FROM "wikis" INNER JOIN "collaborators" ON "collaborators"."wiki_id" = "wikis"."id" WHERE (private = 'f' OR user_id = 18 OR collaborators.user_id = 18)
# => #<Wiki::ActiveRecord_Relation:0x3537854>
#
# [11] pry(main)> Wiki.joins(:collaborators).where('private = ? OR user_id = ? OR collaborators.user_id = ?', false, user.id, user.id)
#   Wiki Load (0.4ms)  SELECT "wikis".* FROM "wikis" INNER JOIN "collaborators" ON "collaborators"."wiki_id" = "wikis"."id" WHERE (private = 'f' OR user_id = 18 OR collaborators.user_id = 18)
# => #<Wiki::ActiveRecord_Relation:0x34fff6c>
#
# [12] pry(main)> Wiki.joins(:collaborators).where('private = ? OR wikis.user_id = ? OR collaborators.user_id = ?', false, user.id, user.id).to_a
#   Wiki Load (0.5ms)  SELECT "wikis".* FROM "wikis" INNER JOIN "collaborators" ON "collaborators"."wiki_id" = "wikis"."id" WHERE (private = 'f' OR user_id = 18 OR collaborators.user_id = 18)
# ActiveRecord::StatementInvalid: SQLite3::SQLException: ambiguous column name: user_id: SELECT "wikis".* FROM "wikis" INNER JOIN "collaborators" ON "collaborators"."wiki_id" = "wikis"."id" WHERE (private = 'f' OR user_id = 18 OR collaborators.user_id = 18)
# from /home/caschotchii/.rvm/gems/ruby-2.3.0@Blocipedia/gems/sqlite3-1.3.12/lib/sqlite3/database.rb:91:in `initialize'
#
# [13] pry(main)> Wiki.joins(:collaborators).where('private = ? OR wikis.user_id = ? OR collaborators.user_id = ?', false, user.id, user.id).to_a
#   Wiki Load (0.2ms)  SELECT "wikis".* FROM "wikis" INNER JOIN "collaborators" ON "collaborators"."wiki_id" = "wikis"."id" WHERE (private = 'f' OR wikis.user_id = 18 OR collaborators.user_id = 18)
# => [#<Wiki:0x000000069665f8
#   id: 51,
#   title: "Private Wiki test",
#   body: "Private Wiki test\r\n\r\nPrivate Wiki test\r\n\r\nPrivate Wiki test\r\n\r\nPrivate Wiki test",
#   private: true,
#   user_id: 17,
#   created_at: Thu, 19 Jan 2017 00:23:49 UTC +00:00,
#   updated_at: Thu, 19 Jan 2017 00:23:49 UTC +00:00>,
#  #<Wiki:0x000000069663a0
#   id: 52,
#   title: "Private Wiki test 2",
#   body: "Private Wiki test 2\r\nPrivate Wiki test 2\r\nPrivate Wiki test 2\r\nPrivate Wiki test 2\r\nPrivate Wiki test 2\r\nPrivate Wiki test 2",
#   private: true,
#   user_id: 16,
#   created_at: Thu, 19 Jan 2017 01:52:32 UTC +00:00,
#   updated_at: Thu, 19 Jan 2017 01:52:32 UTC +00:00>]
