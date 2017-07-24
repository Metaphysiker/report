class CreateUniversities < ActiveRecord::Migration[5.1]
  def change
    create_table :universities do |t|
      t.string :title
      t.belongs_to :report, index: true

      t.timestamps
    end
  end
end
