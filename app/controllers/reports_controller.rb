class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]

  # GET /reports
  # GET /reports.json

  def bloggercsv
    @bloggers = Blogger.all
    respond_to do |format|
      format.csv { send_data @bloggers.to_csv, filename: "Liste-Blogger.csv" }
    end
  end

  def blogger

  end

  def externalposts
    @externalposts = AlchemyPage.where(page_layout: "article").where.not(published_at: nil).all_except(Rails.configuration.philochlerids)
  end

  def comments

    if params[:language].nil?
      @comments = Comment.where.not(confirmed_at: nil)
    else
      lang_comments = []
      Comment.where.not(confirmed_at: nil).each do |comment|
      #Comment.all.each do |comment|
      #Comment.where("created_at > ?", Date.today - 7.days).each do |comment|


        if (AlchemyPage.where(id: comment.commentable_id).exists?) && (AlchemyPage.find(comment.commentable_id).language_code == params[:language])
          lang_comments.push(comment.id)

        end
      end
      @comments = Comment.where(id: lang_comments)
    end

    articles = []
    #@comments = Comment.where.not(confirmed_at: nil)

    Comment.where.not(confirmed_at: nil).each do |comment|
    #Comment.all.each do |comment|
    #Comment.where("created_at > ?", Date.today - 7.days).each do |comment|

      if AlchemyPage.where(id: comment.commentable_id).exists?
        puts comment.id
        articles.push(AlchemyPage.find(comment.commentable_id))
      end
    end

    articles = articles.uniq

    articles = AlchemyPage.where(id: articles.map(&:id))

    @articleswithcomments = articles.order(created_at: :desc)
  end

  def allcomments

    if params[:language].nil?
      @comments = Comment.all
    else
      lang_comments = []
      Comment.all.each do |comment|
      #Comment.all.each do |comment|
      #Comment.where("created_at > ?", Date.today - 7.days).each do |comment|


        if (AlchemyPage.where(id: comment.commentable_id).exists?) && (AlchemyPage.find(comment.commentable_id).language_code == params[:language])
          lang_comments.push(comment.id)

        end
      end
      @comments = Comment.where(id: lang_comments)
    end

    articles = []
    #@comments = Comment.where.not(confirmed_at: nil)

    Comment.where.not(confirmed_at: nil).each do |comment|
    #Comment.all.each do |comment|
    #Comment.where("created_at > ?", Date.today - 7.days).each do |comment|

      if AlchemyPage.where(id: comment.commentable_id).exists?
        puts comment.id
        articles.push(AlchemyPage.find(comment.commentable_id))
      end
    end

    articles = articles.uniq

    articles = AlchemyPage.where(id: articles.map(&:id))

    @articleswithcomments = articles.order(created_at: :desc)
  end

  def liebeundgemeinschaft
    articles = []
    @comments = Comment.where.not(confirmed_at: nil)

    aktuellarticles = getallarticleswithtag("Projekt Liebe und Gemeinschaft")

    Comment.where.not(confirmed_at: nil).each do |comment|
      #Comment.all.each do |comment|
      #Comment.where("created_at > ?", Date.today - 7.days).each do |comment|

      #if AlchemyPage.where(id: comment.commentable_id).exists?

      if aktuellarticles.where(id: comment.commentable_id).exists?
        articles.push(AlchemyPage.find(comment.commentable_id))
      end
    end

    articles = articles.uniq

    @articleswithcomments = articles
  end

  def philosophieaktuell
    articles = []
    #@comments = Comment.where.not(confirmed_at: nil)

    aktuellarticles = getallarticleswithtag("Projekt Philosophie aktuell")

    Comment.where.not(confirmed_at: nil).each do |comment|
      #Comment.all.each do |comment|
      #Comment.where("created_at > ?", Date.today - 7.days).each do |comment|

      #if AlchemyPage.where(id: comment.commentable_id).exists?

      if aktuellarticles.where(id: comment.commentable_id).exists?
        articles.push(AlchemyPage.find(comment.commentable_id))
      end
    end

    articles = articles.uniq

    @articleswithcomments = articles
  end

  def auswahl
    @firsthalfyear = Report.find_by_name("firsthalfyear")
    @thirdquarter = Report.find_by_name("thirdquarter")
    @secondhalfyear =  Report.find_by_name("secondhalfyear")
    @alltime = Report.find_by_name("alltime")
  end

  def firsthalfyear
    @report = Report.first
  end

  def general

   # @reports = Report.all

    #@interests = count_chosen_topics("member")

    #@generalinformation = analyze(Report.last)

#    @unis = Report.last.universities

 #   @stacked_interests = count_chosen_topics_stacked("member")

   # memberinos = {}
    #Report.all.order(:date).each do |report|
     # memberinos[report.date] = report.general["members"]
    #end
    #@memberinos = memberinos


  end

  def index
    @reports = Report.where(specialreport: false)

    @specialreports = Report.where(specialreport: true)


    @interests = count_chosen_topics("member")
  end

  # GET /reports/1
  # GET /reports/1.json
  def show

    gon.newsletteraktiv = @report

    gon.otherinstitutionschart = @report.societies

    allgemeingroupinterests = @report.allgemeingroupinterests.to_h

    gon.interesseallgemein = allgemeingroupinterests
  end

  # GET /reports/new
  def new
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(report_params)
    analyze(@report)
    respond_to do |format|
      if @report.save

        unis(@report)
        format.html { redirect_to @report, notice: 'Report was successfully created.' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def calculatenew(value, range)

  end


  def addblogger
    blogger_id = params[:blogger_id]
    blogger_interests = params[:blogger_interests]

    Blogger.create(blogger_id: blogger_id, interests: blogger_interests)

    redirect_to blogger_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(:date)
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

  def getallarticleswithtag(tag)
    list = []
    AlchemyPage.where(page_layout: "article").each do |article|

      element = AlchemyElement.where(page_id: article.id).where(name: "intro")

      content = AlchemyContent.where(element_id: element.last.id).where(essence_type: "Alchemy::EssenceTopic")

      topics_ids = AlchemyEssenceTopicsTopic.where(alchemy_essence_topic_id: content.last.essence_id)


      topics_ids.each do |topic|

        if Topic.find(topic.topic_id).name == tag
          list.push(article)
          break
        end

      end
    end
    ids = list.collect{|u| u.id}
    AlchemyPage.where(page_layout: "article").where(id: ids)
  end




end
