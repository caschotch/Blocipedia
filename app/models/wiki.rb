class Wiki < ActiveRecord::Base
  belongs_to :user

# tested application of scope to show only to premium users the private wikis
# it works but will do it through policies so it is more flexible with later expansion

  # scope :not_private, -> { where("private is NULL or private = ?", false) }
  # scope :visible_to, -> (user) {user && user.premium? ? all : not_private }

end
