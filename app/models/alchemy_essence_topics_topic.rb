class AlchemyEssenceTopicsTopic < ApplicationRecord
  belongs_to :alchemy_pages
  belongs_to :topics
  self.table_name = "alchemy_essence_topics_topics"
end