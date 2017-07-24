class WelcomeController < ApplicationController
  def index

    @topics = count_chosen_topics
  end

  def count_chosen_topics
    all_topics = Topic.all.distinct.pluck(:name)
    hash_of_all_topics= {}
    all_topics.each{|a| hash_of_all_topics[a] = 0}

    Profile.all.each do |profile|
      profile.topics.uniq.each do |topic|
        unless hash_of_all_topics[topic.name].nil?
          hash_of_all_topics[topic.name] = hash_of_all_topics[topic.name] + 1
        end

      end
    end

    logger.debug hash_of_all_topics
    return hash_of_all_topics
  end
end
