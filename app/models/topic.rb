class Topic < ApplicationRecord
  has_many :profile_topics
  has_many :profiles, through: :profile_topics
  self.table_name = "topics"
  has_many :alchemy_essence_topics_topics
  has_many :alchemy_pages, through: :alchemy_essence_topics_topics
end
