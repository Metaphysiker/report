class AddInformationToUniversities < ActiveRecord::Migration[5.1]
  def change
    add_column :universities, :information, :hstore
    add_index :universities, :information, using: :gin
  end
end
