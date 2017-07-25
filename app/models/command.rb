class Command
  def create(date)
    @report = Report.create(date)
    analyze(@report)
    unis(@report)
  end

  def analyze(report)

    allprofiles = Profile.all.count
    members = AlchemyUser.where(alchemy_roles: "member").count
    institutions = AlchemyUser.where(alchemy_roles: "institution").count
    public = Profile.where(public: true).count
    private = Profile.where(public: false).count
    allgemein = Profile.where(level: 0).count
    expert = Profile.where(level: 1).count

    report.general = {
        allprofiles: allprofiles,
        members: members,
        institutions: institutions,
        public: public,
        private: private,
        allgemein: allgemein,
        expert: expert
    }

    report.save!
    return report.general

  end

  def unis(report)
    all_unis = Profile.all.distinct.pluck(:institutional_affiliation)
    all_unis.each do |uni|

      university = report.universities.create(title: uni)

      hash = {}

      types = Profile.where(institutional_affiliation: uni).pluck(:type_of_affiliation)

      types.each do |type|
        hash[type] = Profile.where(institutional_affiliation: uni).where(type_of_affiliation: type).count
      end

      university.information = hash

      university.save!

    end

  end

  def count_chosen_topics(scope = nil)
    all_topics = Topic.all.distinct.pluck(:name)
    hash_of_all_topics= {}
    all_topics.each{|a| hash_of_all_topics[a] = 0}


    Profile.all.each do |profile|

      if scope.nil?
        count_topics(profile, hash_of_all_topics)
      elsif AlchemyUser.find(profile.id).alchemy_roles == scope
        count_topics(profile, hash_of_all_topics)
      end

    end

    return hash_of_all_topics.sort {|a,b| a[1]<=>b[1]}.reverse
  end

  def count_chosen_topics_stacked(scope = nil)

    all_topics = Topic.all.distinct.pluck(:name)
    hash_of_all_topics= {}
    all_topics.each{|a| hash_of_all_topics[a] = 0}

    expert_data = hash_of_all_topics.clone
    allgemein_data = hash_of_all_topics.clone

    expert_array = []
    allgemein_array = []

    final_array = []

    Profile.all.each do |profile|

      if AlchemyUser.find(profile.id).alchemy_roles == scope
        if profile.level == 1
          count_topics(profile, expert_data)
        else
          count_topics(profile, allgemein_data)
        end
      end
    end

    ordered_array = count_chosen_topics(scope)
    logger.debug ordered_array.inspect

    ordered_array.each do |element|
      logger.debug element.inspect
      element[1] = expert_data[element[0]]
      logger.debug element.inspect
    end

    expert_array = ordered_array

    allgemein_data.each do |key, value|
      allgemein_array.push([key, value])
    end

    final_array = [
        {
            name: "Experten",
            data: expert_array
        },
        {
            name: "Allgemein",
            data: allgemein_array
        }
    ]

    return final_array
  end

  def count_all_profiles
    Profile.all.count
  end

  def count_topics(profile, hash)
    profile.topics.uniq.each do |topic|
      unless hash[topic.name].nil?
        hash[topic.name] = hash[topic.name] + 1
      end
    end
  end
end