class AddGeneralToReports < ActiveRecord::Migration[5.1]
  def change
    enable_extension "hstore"
    add_column :reports, :general, :hstore
    add_index :reports, :general, using: :gin
  end
end
