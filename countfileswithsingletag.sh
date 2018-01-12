#!/usr/bin/env bash


list = []
AlchemyPage.where(page_layout: "article").each do |article|
  element = AlchemyElement.where(page_id: article.id).where(name: "intro")
  content = AlchemyContent.where(element_id: element.last.id).where(essence_type: "Alchemy::EssenceTopic")
  topics_ids = AlchemyEssenceTopicsTopic.where(alchemy_essence_topic_id: content.last.essence_id)
  topico = topics_ids.first

  if (topics_ids.count == 1) && (Topic.find(topico.topic_id).name == "applied ethics")
    list << article
  end
end

puts list.count