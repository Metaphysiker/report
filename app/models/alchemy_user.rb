class AlchemyUser < ApplicationRecord
  belongs_to :profile
  self.table_name = "alchemy_users"
end
