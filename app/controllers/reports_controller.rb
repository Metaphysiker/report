class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]

  # GET /reports
  # GET /reports.json
  def general

    @reports = Report.all

    @interests = count_chosen_topics("member")

    @generalinformation = analyze(Report.last)

    @unis = Report.last.universities

    memberinos = {}
    Report.all.order(:date).each do |report|
      memberinos[report.date] = report.general["members"]
    end
    @memberinos = memberinos


  end

  def index
    @reports = Report.all

    memberinos = {}
    Report.all.order(:date).each do |report|
      memberinos[report.date] = report.general["members"]
    end
    @memberinos = memberinos

    @interests = count_chosen_topics("member")
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
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
      logger.debug uni.inspect
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



