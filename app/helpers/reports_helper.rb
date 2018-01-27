module ReportsHelper
  def countphilochler(list)

    philochler = 0
    # 7 = Sandro, 512 = Steve Wattson, 375 = kantumik, 513 = Hadron
    philochlerids = [7, 512, 513, 375]

    list.each do |comment|
      if philochlerids.include?(comment.user_id)
        philochler = philochler + 1
      end
    end

    philochler
  end
end
