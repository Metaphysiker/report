class Command
  def create(date)
    @report = Report.create(date)
    general(@report)
    unis(@report)
  end

  def general(report)

    allprofiles = Profile.all.count
    members = AlchemyUser.where(alchemy_roles: "member").count
    institutions = AlchemyUser.where(alchemy_roles: "institution").count
    public = Profile.where(public: true).count
    private = Profile.where(public: false).count
    allgemein = Profile.where(level: 0).count
    expert = Profile.where(level: 1).count
    belongtouni = Profile.where.not(institutional_affiliation: "").count
    belongtonouni = Profile.where(institutional_affiliation: "").count

    report.profileerstellt = AlchemyUser.where(alchemy_roles: "member").group_by_week(:created_at).count
    report.kommentareerstellt = Comment.group_by_week(:created_at).count
    report.eventserstellt =  AlchemyPage.where(page_layout: "event").group_by_week(:created_at).count
    report.artikelerstellt = AlchemyPage.where(page_layout: "article").group_by_week(:created_at).count
    report.cfperstellt = AlchemyPage.where(page_layout: "call_for_papers").group_by_week(:created_at).count
    report.jobserstellt = AlchemyPage.where(page_layout: "job").group_by_week(:created_at).count
    report.newslettererstellt = Subscription.group_by_week(:created_at).count
    report.zuletztangemeldet = AlchemyUser.where(alchemy_roles: "member").group_by_month(:last_sign_in_at).count

    newsletteraktiv = Subscription.where(active: true).count
    newslettertotal = Subscription.all.count

    report.general = {
        allprofiles: allprofiles,
        members: members,
        institutions: institutions,
        public: public,
        private: private,
        allgemein: allgemein,
        expert: expert,
        belongtouni: belongtouni,
        belongtonouni: belongtonouni,
        newsletteraktiv: newsletteraktiv,
        newslettertotal: newslettertotal
    }

    report.stackedinterests = count_chosen_topics_stacked("member")
    report.save!

  end

  def interests(report)

    stacked_interests = count_chosen_topics_stacked("member")
    interests = count_chosen_topics("member")

    report.interests = {
        stacked_interests: stacked_interests,
        interests: interests
    }

    report.save!

  end


  def unis(report)
    all_unis = Profile.all.distinct.pluck(:institutional_affiliation)

    all_unis.delete("")

    all_unis.each do |uni|

      university = report.universities.create(title: uni)

      hash = {}

      types = Profile.where(institutional_affiliation: uni).pluck(:type_of_affiliation)

      types.each do |type|

        name = type
        results = Profile.where(institutional_affiliation: uni).where(type_of_affiliation: type).count

        if type.nil? || type.empty?
          name = "institution"
        end

        hash[name] = results

      university.information = hash

      university.save

    end

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

    ordered_array.each do |element|
      element[1] = expert_data[element[0]]
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

    final_array = [
        expert_array,
        allgemein_array
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