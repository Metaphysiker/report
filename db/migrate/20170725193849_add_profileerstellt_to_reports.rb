class AddProfileerstelltToReports < ActiveRecord::Migration[5.1]
  def change

    add_column :reports, :specialreport, :boolean, :default => false
    add_column :reports, :whichbackup, :date

    add_column :reports, :startdate, :date
    add_column :reports, :enddate, :date

    add_column :reports, :profileerstellt, :hstore
    add_index :reports, :profileerstellt, using: :gin

    add_column :reports, :profiletotal, :hstore
    add_index :reports, :profiletotal, using: :gin

    add_column :reports, :kommentareerstellt, :hstore
    add_index :reports, :kommentareerstellt, using: :gin

    add_column :reports, :kommentaretotal, :hstore
    add_index :reports, :kommentaretotal, using: :gin

    add_column :reports, :eventserstellt, :hstore
    add_index :reports, :eventserstellt, using: :gin

    add_column :reports, :eventstotal, :hstore
    add_index :reports, :eventstotal, using: :gin

    add_column :reports, :artikelerstellt, :hstore
    add_index :reports, :artikelerstellt, using: :gin

    add_column :reports, :artikeltotal, :hstore
    add_index :reports, :artikeltotal, using: :gin

    add_column :reports, :jobserstellt, :hstore
    add_index :reports, :jobserstellt, using: :gin

    add_column :reports, :jobstotal, :hstore
    add_index :reports, :jobstotal, using: :gin

    add_column :reports, :cfperstellt, :hstore
    add_index :reports, :cfperstellt, using: :gin

    add_column :reports, :cfptotal, :hstore
    add_index :reports, :cfptotal, using: :gin

    add_column :reports, :newslettererstellt, :hstore
    add_index :reports, :newslettererstellt, using: :gin

    add_column :reports, :newslettertotal, :hstore
    add_index :reports, :newslettertotal, using: :gin

    add_column :reports, :zuletztangemeldet, :hstore
    add_index :reports, :zuletztangemeldet, using: :gin

    add_column :reports, :stackedinterests, :string, array: true, default: []

  end
end
