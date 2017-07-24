class ProfileTopic < ApplicationRecord
  self.table_name = "profiles_topics"
  belongs_to :profile
  belongs_to :topic
end

