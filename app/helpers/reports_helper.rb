module ReportsHelper
  def countphilochler(list)

    philochler = 0
    # 7 = Sandro, 512 = Steve Wattson, 375 = kantumik, 513 = Hadron, 1 = Emanuel, 2 = Anja, 3 = Carole, 4 = Philipp
    # 5 = Franziska, 6 = Sahra, 8 = benjamin
    # philochlerids = [1,2,3,4,6,7,8, 512, 513, 375]
      philochlerids = Rails.configuration.philochlerids
    list.each do |comment|
      if philochlerids.include?(comment.user_id)
        philochler = philochler + 1
      end
    end

    philochler
  end

  def returnname(creator_id)
    #u = AlchemyUser.find(creator_id)
    if AlchemyUser.where(id: creator_id).present?
      u = AlchemyUser.find(creator_id)
      if !u.firstname.blank?
        u.firstname + " " + u.lastname
      else
        u.login
      end

    else
      "User nicht gefunden"
    end
  end
end
