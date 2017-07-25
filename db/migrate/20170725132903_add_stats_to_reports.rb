class AddStatsToReports < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :stats, :hstore
    add_index :reports, :stats, using: :gin
  end
end
