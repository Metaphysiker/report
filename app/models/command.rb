class Command
  def create(date)
    @report = Report.create(date)
    general(@report)
    unis(@report)
  end

  def specialcreate(name, date, startdate, enddate)
    @report = Report.create(date: date, name: name)
    special(@report, startdate, enddate)
    unisspecial(@report, enddate)
    societyspecial(@report, enddate)
  end

  def special(report, startdate=nil, enddate=nil)
    report.specialreport = true
    report.whichbackup = report.date

    startdate = startdate
    enddate = enddate

    if startdate.nil?
      startdate = AlchemyUser.order('created_at asc').where.not(created_at: nil).first.created_at.to_date
    end

    if enddate.nil?
      enddate = AlchemyUser.order('created_at asc').where.not(created_at: nil).last.created_at.to_date
    end

    allprofiles = Profile.where("created_at < ?", enddate).count
    members = AlchemyUser.where(alchemy_roles: "member").where("created_at < ?", enddate).count
    institutions = AlchemyUser.where(alchemy_roles: "institution").where("created_at < ?", enddate).count
    public = Profile.where(public: true).where("created_at < ?", enddate).count
    private = Profile.where(public: false).where("created_at < ?", enddate).count
    allgemein = Profile.where(level: 0).where("created_at < ?", enddate).count
    expert = Profile.where(level: 1).where("created_at < ?", enddate).count
    belongtouni = Profile.where.not(institutional_affiliation: "").where("created_at < ?", enddate).count
    belongtonouni = Profile.where(institutional_affiliation: "").where("created_at < ?", enddate).count
    german = AlchemyUser.where(language: "de").where("created_at < ?", enddate).count
    french = AlchemyUser.where(language: "fr").where("created_at < ?", enddate).count
    interested_in_education = Profile.where(interested_in_education: "yes").where("created_at < ?", enddate).count

    report.startdate = startdate
    report.enddate = enddate
    #report.profileerstellt = AlchemyUser.where(alchemy_roles: "member").group_by_week(:created_at, range: startdate..enddate).count
    report.profileerstellt = weekcalculator(AlchemyUser.where(alchemy_roles: "member"), startdate, enddate)
    report.profiletotal = totalareacalculator(AlchemyUser.where(alchemy_roles: "member"), startdate, enddate)
    #report.kommentareerstellt = Comment.group_by_week(:created_at, range: startdate..enddate).count
    #report.kommentareerstellt = weekcalculator(Comment.all, startdate, enddate)
    #report.kommentaretotal = totalareacalculator(Comment.all, startdate, enddate)
    report.kommentareerstellt = weekcalculator(Comment.where.not(confirmed_at: nil), startdate, enddate)
    report.kommentaretotal = totalareacalculator(Comment.where.not(confirmed_at: nil), startdate, enddate)
    #report.eventserstellt =  AlchemyPage.where(page_layout: "event").group_by_week(:created_at, range: startdate..enddate).count
    report.eventserstellt = weekcalculator(AlchemyPage.where(page_layout: "event"), startdate, enddate)
    report.eventstotal = totalareacalculator(AlchemyPage.where(page_layout: "event"), startdate, enddate)
    #report.artikelerstellt = AlchemyPage.where(page_layout: "article").group_by_week(:created_at, range: startdate..enddate).count
    report.artikelerstellt = weekcalculator(AlchemyPage.where(page_layout: "article"), startdate, enddate)
    report.artikeltotal = totalareacalculator(AlchemyPage.where(page_layout: "article"), startdate, enddate)
   # report.cfperstellt = AlchemyPage.where(page_layout: "call_for_papers").group_by_week(:created_at, range: startdate..enddate).count
    report.cfperstellt = weekcalculator(AlchemyPage.where(page_layout: "call_for_papers"), startdate, enddate)
    report.cfptotal = totalareacalculator(AlchemyPage.where(page_layout: "call_for_papers"), startdate, enddate)
   # report.jobserstellt = AlchemyPage.where(page_layout: "job").group_by_week(:created_at, range: startdate..enddate).count
    report.jobserstellt = weekcalculator(AlchemyPage.where(page_layout: "job"),startdate, enddate)
    report.jobstotal = totalareacalculator(AlchemyPage.where(page_layout: "job"),startdate, enddate)
   # report.newslettererstellt = Subscription.group_by_week(:created_at, range: startdate..enddate).count
    report.newslettererstellt = weekcalculator(Subscription.all, startdate, enddate)
    report.newslettertotal = totalareacalculator(Subscription.all, startdate, enddate)
    report.zuletztangemeldet = AlchemyUser.where(alchemy_roles: "member").group_by_month(:last_sign_in_at, range: startdate..enddate).count
    report.lehrpersonentotal = totalareacalculator(Profile.where.not(teacher_at_institution: ""), startdate, enddate)
    report.interestedineducationtotal = totalareacalculator(Profile.where(interested_in_education: "yes"), startdate, enddate)

    #newsletteraktiv = Subscription.where(active: true).where("created_at < ?", enddate).count
    newslettersvalid = Subscription.where(active: true).where("valid_until > ?", report.date).where("created_at < ?", enddate)
    newslettersuni = Subscription.where(active: true).where("created_at < ?", enddate) - newslettersvalid
    activeandvalidcount = newslettersvalid.count + newslettersuni.count

    newslettersuni.each do |n|
      if Profile.find(n.profile_id).institutional_affiliation == "" || Profile.find(n.profile_id).institutional_affiliation == "other"
        activeandvalidcount -=1
      end
    end

    newsletteraktiv = activeandvalidcount
    newslettertotal = Subscription.where("created_at < ?", enddate).count

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
        german: german,
        french: french,
        interested_in_education: interested_in_education,
        newsletteraktiv: newsletteraktiv,
        newslettertotal: newslettertotal
    }

    report.allgemeingroupinterests = count_allgemein_topic_groups
    report.stackedinterests = count_chosen_topics_stacked("member")
    report.articleanalysis = articleanalysis(enddate)
    report.eventanalysis = eventanalysis(enddate)
    report.save!

  end

  def articleanalysis(enddate)
    all_topics = Topic.all.distinct.pluck(:name)
    hash_of_all_topics= {}
    all_topics.each{|a| hash_of_all_topics[a] = 0}

    AlchemyPage.where(page_layout: "article").where("created_at < ?", enddate).each do |article|

     element = AlchemyElement.where(page_id: article.id).where(name: "intro")

     content = AlchemyContent.where(element_id: element.last.id).where(essence_type: "Alchemy::EssenceTopic")

     topics_ids = AlchemyEssenceTopicsTopic.where(alchemy_essence_topic_id: content.last.essence_id)


     topics_ids.each do |topic|
      topico = Topic.find(topic.topic_id)
      hash_of_all_topics[topico.name] = hash_of_all_topics[topico.name] + 1
     end
    end

    #puts hash_of_all_topics.sort_by{|k,v| v}
    return hash_of_all_topics.sort_by{|k,v| v}
    #report.articleanalysis = hash_of_all_topics
  end

  def eventanalysis(enddate)
    all_topics = Topic.all.distinct.pluck(:name)
    hash_of_all_topics= {}
    all_topics.each{|a| hash_of_all_topics[a] = 0}

    AlchemyPage.where(page_layout: "event").where("created_at < ?", enddate).each do |article|

      element = AlchemyElement.where(page_id: article.id).where(name: "event_intro")

      content = AlchemyContent.where(element_id: element.last.id).where(essence_type: "Alchemy::EssenceTopic")

      topics_ids = AlchemyEssenceTopicsTopic.where(alchemy_essence_topic_id: content.last.essence_id)


      topics_ids.each do |topic|
        topico = Topic.find(topic.topic_id)
        hash_of_all_topics[topico.name] = hash_of_all_topics[topico.name] + 1
      end
    end

    #puts hash_of_all_topics.sort_by{|k,v| v}
    return hash_of_all_topics.sort_by{|k,v| v}
    #report.articleanalysis = hash_of_all_topics
  end


  def unisspecial(report, enddate)
    all_unis = Profile.all.distinct.pluck(:institutional_affiliation)

    all_unis.delete("")

    #"{all_unis}".map! {|item| item.humanize.downcase}

    all_unis.each do |uni|
      next if uni.nil?
      university = report.universities.create(title: uni.humanize.downcase)

      hash = {}

      types = Profile.where(institutional_affiliation: uni).pluck(:type_of_affiliation)

      types.each do |type|

        name = type
        results = Profile.where(institutional_affiliation: uni).where(type_of_affiliation: type).where("created_at < ?", enddate).count

        if type.nil? || type.empty?
          name = "institution"
        end

        hash[name] = results

        university.information = hash

        university.save

      end

    end
  end

  def societyspecial(report, enddate)
    all_societies = Society.all
    hash = {}

    all_societies.each do |society|
      hash[society.name] = Profile.where(society_id: society.id).where("created_at < ?", enddate).count
    end

    report.societies = hash
    report.save
  end




  def general1(report, startdate=nil, enddate=nil)

    startdate = startdate
    enddate = enddate

    if startdate.nil?
      startdate = AlchemyUser.order('created_at asc').where.not(created_at: nil).first.created_at.to_date
    end

    if enddate.nil?
      enddate = AlchemyUser.order('created_at asc').where.not(created_at: nil).last.created_at.to_date
    end

    allprofiles = Profile.all.count
    members = AlchemyUser.where(alchemy_roles: "member").count
    institutions = AlchemyUser.where(alchemy_roles: "institution").count
    public = Profile.where(public: true).count
    private = Profile.where(public: false).count
    allgemein = Profile.where(level: 0).count
    expert = Profile.where(level: 1).count
    belongtouni = Profile.where.not(institutional_affiliation: "").count
    belongtonouni = Profile.where(institutional_affiliation: "").count

    report.startdate = startdate
    report.enddate = enddate
    report.profileerstellt = AlchemyUser.where(alchemy_roles: "member").group_by_week(:created_at).count
    report.profiletotal = totalareacalculator(AlchemyUser.where(alchemy_roles: "member"))
    report.kommentareerstellt = Comment.group_by_week(:created_at).count
    report.kommentaretotal = totalareacalculator(Comment.all)
    report.eventserstellt =  AlchemyPage.where(page_layout: "event").group_by_week(:created_at).count
    report.eventstotal = totalareacalculator(AlchemyPage.where(page_layout: "event"))
    report.artikelerstellt = AlchemyPage.where(page_layout: "article").group_by_week(:created_at).count
    report.artikeltotal = totalareacalculator(AlchemyPage.where(page_layout: "article"))
    report.cfperstellt = AlchemyPage.where(page_layout: "call_for_papers").group_by_week(:created_at).count
    report.cfptotal = totalareacalculator(AlchemyPage.where(page_layout: "call_for_papers"))
    report.jobserstellt = AlchemyPage.where(page_layout: "job").group_by_week(:created_at).count
    report.jobstotal = totalareacalculator(AlchemyPage.where(page_layout: "job"))
    report.newslettererstellt = Subscription.group_by_week(:created_at).count
    report.newslettertotal = totalareacalculator(Subscription.all)
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

  def general(report, startdate=nil, enddate=nil)

    report.specialreport = false
    report.whichbackup = report.date

    startdate = startdate
    enddate = enddate

    if startdate.nil?
      startdate = AlchemyUser.order('created_at asc').where.not(created_at: nil).first.created_at.to_date
    end

    if enddate.nil?
      enddate = AlchemyUser.order('created_at asc').where.not(created_at: nil).last.created_at.to_date
    end

    allprofiles = Profile.all.count
    members = AlchemyUser.where(alchemy_roles: "member").count
    institutions = AlchemyUser.where(alchemy_roles: "institution").count
    public = Profile.where(public: true).count
    private = Profile.where(public: false).count
    allgemein = Profile.where(level: 0).count
    expert = Profile.where(level: 1).count
    belongtouni = Profile.where.not(institutional_affiliation: "").count
    belongtonouni = Profile.where(institutional_affiliation: "").count

    report.startdate = startdate
    report.enddate = enddate
    #report.profileerstellt = AlchemyUser.where(alchemy_roles: "member").group_by_week(:created_at, range: startdate..enddate).count
    report.profileerstellt =
    report.profiletotal = totalareacalculator(AlchemyUser.where(alchemy_roles: "member"), startdate, enddate)
    report.kommentareerstellt = Comment.group_by_week(:created_at, range: startdate..enddate).count
    report.kommentaretotal = totalareacalculator(Comment.all, startdate, enddate)
    report.eventserstellt =  AlchemyPage.where(page_layout: "event").group_by_week(:created_at, range: startdate..enddate).count
    report.eventstotal = totalareacalculator(AlchemyPage.where(page_layout: "event"), startdate, enddate)
    report.artikelerstellt = AlchemyPage.where(page_layout: "article").group_by_week(:created_at, range: startdate..enddate).count
    report.artikeltotal = totalareacalculator(AlchemyPage.where(page_layout: "article"), startdate, enddate)
    report.cfperstellt = AlchemyPage.where(page_layout: "call_for_papers").group_by_week(:created_at, range: startdate..enddate).count
    report.cfptotal = totalareacalculator(AlchemyPage.where(page_layout: "call_for_papers"), startdate, enddate)
    report.jobserstellt = AlchemyPage.where(page_layout: "job").group_by_week(:created_at, range: startdate..enddate).count
    report.jobstotal = totalareacalculator(AlchemyPage.where(page_layout: "job"),startdate, enddate)
    report.newslettererstellt = Subscription.group_by_week(:created_at, range: startdate..enddate).count
    report.newslettertotal = totalareacalculator(Subscription.all, startdate, enddate)
    report.zuletztangemeldet = AlchemyUser.where(alchemy_roles: "member").group_by_month(:last_sign_in_at, range: startdate..enddate).count

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

    all_unis.map! {|item| item.humanize.downcase}

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
      elsif !AlchemyUser.where(id: profile.id).empty? && AlchemyUser.find(profile.id).alchemy_roles == scope
        count_topics(profile, hash_of_all_topics)
      end

    end

    return hash_of_all_topics.sort {|a,b| a[1]<=>b[1]}.reverse
  end

  def count_allgemein_topic_groups

    hash_of_topic_groups = {
      "Logik, Wissen, Wissenschaft" => 0,
      "Menschsein und Sprache" => 1,
      "Ethik, Gesellschaft, Kultur" => 2,
      "Geschichte der Philosophie" => 3,
      "Ästhetik" => 4,
      "Administrative Infos, Humor und Zitate" => 5
    }

    final_hash_of_topic_groups = {
        "Logik, Wissen, Wissenschaft" => 0,
        "Menschsein und Sprache" => 0,
        "Ethik, Gesellschaft, Kultur" => 0,
        "Geschichte der Philosophie" => 0,
        "Ästhetik" => 0,
        "Administrative Infos, Humor und Zitate" => 0
    }


    Profile.where(level:0).each do |profile|
      next if AlchemyUser.where(id: profile.id).empty?
      next if AlchemyUser.find(profile.id).alchemy_roles != "member"
      next if profile.topics.empty?

      hash_of_topic_groups.each do |key, value|
        #if Topic.where(group: value).count == profile.topics.where(group: value).count

        if profile.topics.where(group: value).count > 0

        final_hash_of_topic_groups[key] += 1
        end
      end

    end
    return final_hash_of_topic_groups.sort {|a,b| a[1]<=>b[1]}.reverse
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
      next if AlchemyUser.where(id: profile.id).empty?
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

  def totalareacalculator(query, startdate=nil, enddate=nil)

    hash = {}

    startdate = startdate
    enddate = enddate

    if startdate.nil?
      startdate = query.order('created_at asc').where.not(created_at: nil).first.created_at
    end

    if enddate.nil?
      enddate = query.order('created_at asc').where.not(created_at: nil).last.created_at
    end

    point_in_time = startdate

    while point_in_time <= enddate
      hash[point_in_time] = query.where("created_at < ?", point_in_time).count

      if (point_in_time + 7.days) > enddate
        hash[enddate] = query.where("created_at < ?", enddate).count
        break
      else
        point_in_time = point_in_time  + 7.days
      end

    end

    return hash

  end

  def weekcalculator(query, startdate=nil, enddate=nil)

    hash = {}

    startdate = startdate
    enddate = enddate

    if startdate.nil?
      startdate = query.order('created_at asc').where.not(created_at: nil).first.created_at
    end

    if enddate.nil?
      enddate = query.order('created_at asc').where.not(created_at: nil).last.created_at
    end

    point_in_time = startdate

    hash[point_in_time] = query.where("created_at < ?", point_in_time).count - query.where("created_at < ?", point_in_time - 7.days).count

    point_in_time = point_in_time  + 7.days

    while point_in_time <= enddate
      hash[point_in_time] = query.where("created_at < ?", point_in_time + 7.days).count - query.where("created_at < ?", point_in_time).count

      if ((point_in_time + 7.days) > enddate) && point_in_time != enddate
        hash[enddate] = query.where("created_at < ?", enddate).count - query.where("created_at < ?", point_in_time).count
        break
      else
        point_in_time = point_in_time  + 7.days
      end

    end

    return hash

  end

end
