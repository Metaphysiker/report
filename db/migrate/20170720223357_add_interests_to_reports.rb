class AddInterestsToReports < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :interests, :hstore
    add_index :reports, :interests, using: :gin
  end
end
