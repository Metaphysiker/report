class Profile < ApplicationRecord
  self.table_name = "profiles"
  has_many :profile_topics
  has_many :topics, through: :profile_topics
  has_one :alchemy_user
  has_many :alchemy_pages
end
