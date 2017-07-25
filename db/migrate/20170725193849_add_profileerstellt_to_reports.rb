class AddProfileerstelltToReports < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :profileerstellt, :hstore
    add_index :reports, :profileerstellt, using: :gin

    add_column :reports, :kommentareerstellt, :hstore
    add_index :reports, :kommentareerstellt, using: :gin

    add_column :reports, :eventserstellt, :hstore
    add_index :reports, :eventserstellt, using: :gin

    add_column :reports, :artikelerstellt, :hstore
    add_index :reports, :artikelerstellt, using: :gin

    add_column :reports, :jobserstellt, :hstore
    add_index :reports, :jobserstellt, using: :gin

    add_column :reports, :cfperstellt, :hstore
    add_index :reports, :cfperstellt, using: :gin

    add_column :reports, :newslettererstellt, :hstore
    add_index :reports, :newslettererstellt, using: :gin

    add_column :reports, :zuletztangemeldet, :hstore
    add_index :reports, :zuletztangemeldet, using: :gin

    add_column :reports, :stackedinterests, :string, array: true, default: []

  end
end
