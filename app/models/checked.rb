class Checked
  def wasthereachecktoday?
    #true means: yes there was a check today
    !Check.where(date: Date.today).empty?
  end

  def checkfinished
    Check.create(date: Date.today, passed: "true")
  end

  def remindblogger?

  end

end