class AlchemyPage < ApplicationRecord
  belongs_to :profile
  self.table_name = "alchemy_pages"
  has_many :alchemy_essence_topics_topics
  has_many :topics, through: :alchemy_essence_topics_topics
end