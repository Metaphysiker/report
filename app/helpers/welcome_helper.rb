module WelcomeHelper

  def count_choosers(topicname)
    logger.debug topicname
    counter = 0
    Profile.all.each do |profile|
      profile.topics.uniq.each do |topic|
        logger.debug topic.name
        if topic.name == topicname
          counter = counter + 1
          break
        end
      end
    end
    return counter
  end

  def count_choosers_allgemein(topicname)
    logger.debug topicname
    counter = 0
    Profile.where(level: 1).each do |profile|
      profile.topics.uniq.each do |topic|
        logger.debug topic.name
        if topic.name == topicname
          counter = counter + 1
          break
        end
      end
    end
    return counter
  end

  def count_choosers_expert(topicname)
    logger.debug topicname
    counter = 0
    Profile.where(level: 0).each do |profile|
      profile.topics.uniq.each do |topic|
        logger.debug topic.name
        if topic.name == topicname
          counter = counter + 1
          break
        end
      end
    end
    return counter
  end

end
