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

end