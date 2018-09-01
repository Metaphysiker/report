class AlchemyPage < ApplicationRecord
  belongs_to :profile
  self.table_name = "alchemy_pages"
  has_many :alchemy_essence_topics_topics
  has_many :topics, through: :alchemy_essence_topics_topics

  scope :all_except, ->(ids) { where.not(creator_id: ids) }

    def url
      "www.philosophie.chx"
    end

    def lead

      element = AlchemyElement.where(page_id: self.id).where(name: "intro")
      content = AlchemyContent.where(element_id: element.last.id).where(essence_type: "Alchemy::EssenceRichtext")
    end


end
