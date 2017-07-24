class Report < ApplicationRecord
  has_many :universities
  store_accessor :general
  store_accessor :interests
end
