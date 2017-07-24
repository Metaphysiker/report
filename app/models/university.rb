class University < ApplicationRecord
  belongs_to :report
  store_accessor :preferences
end
