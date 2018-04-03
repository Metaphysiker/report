namespace :checkforendingdeadlines do

  desc "Checking for ending deadlines"
  task normalcheck: :environment do
    firstdate = Date.today - 7.days
    enddate = Date.today + 7.days
    daterange = firstdate..enddate
    deadliningbloggers = []
    Blogger.all.each do |blogger|

      if blogger.deadline && (daterange === blogger.deadline)
        deadliningbloggers.push(blogger.name)
      end
    end
    if deadliningbloggers.empty?
      message = "No deadlining bloggers"
    else
      message = deadliningbloggers
    end

    puts message
    #puts `kdialog --title "Deadlining bloggers:" --passivepopup \ #{message} 10`
    #puts `logger #{message}`
  end

  desc "check time distances from last entry"
  task checktimedistance: :environment do

    quarter = []
    half = []
    Blogger.all.each do |blogger|

      if blogger.lastentry.is_a? ActiveSupport::TimeWithZone

        if blogger.lastentry + 6.months < Date.today
          half.push(blogger.name)
        elsif blogger.lastentry + 3.months < Date.today
          quarter.push(blogger.name)
        end

      end

    end

    puts "quarters: " + quarter.to_s + " halfs: " + half.to_s

    #puts `kdialog --title "Deadlining bloggers:" --passivepopup \ #{message} 10`
    #puts `logger #{message}`
  end

end