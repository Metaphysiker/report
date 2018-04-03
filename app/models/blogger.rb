class Blogger < ApplicationRecord

  def self.to_csv
    #attributes = %w{Benutzername ID reminded}
    attributes = ["Name", "Benutzername", "ID", "Anzahl Beiträge", "Interessensgebiet", "Letzter Beitrag", "Letzte Erinnerung erhalten"]

    CSV.generate(headers: true) do |csv|
      csv << ["BITTE NICHTS EINTRAGEN! ALLE VERÄNDERUNGEN WERDEN AUTOMATISCH GELÖSCHT!"]
      csv << ["Übersicht auf https://reportseite.herokuapp.com//blogger."]
      csv << ["Erstellungsdatum: " + Date.today.to_s]
      csv << [" "]
      csv << attributes

      all.each do |blogger|
        #csv << attributes.map{ |attr| blogger.send(attr) }
        csv << [blogger.name, blogger.loginname, blogger.blogger_id, blogger.entriescount, blogger.interests, blogger.lastentry, blogger.reminderstatus]
      end
    end
  end

  def name
    AlchemyUser.find(self.blogger_id).firstname.to_s + " " + AlchemyUser.find(self.blogger_id).lastname.to_s
  end

  def loginname
    AlchemyUser.find(self.blogger_id).login
  end

  def entriescount
    AlchemyPage.where(creator_id: self.blogger_id).where(page_layout: "article").count
  end

  def lastentry
    entry = AlchemyPage.where(page_layout: "article").where(creator_id: self.blogger_id).order("created_at").last
    if entry.nil?
      return "noch kein Eintrag"
    else
     return entry.created_at
    end
  end

  def reminderstatus
    if self.reminded.nil?
      return "noch keine Erinnerung erhalten"
    else
      return self.reminded
    end
  end

  def deadlinestatus
    if self.deadline.nil?
      return "table-warning"
    elsif self.deadline > Date.today
      return "table-success"
    else
      return "table-danger"
    end
  end

end
