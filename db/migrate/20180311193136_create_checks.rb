class CreateChecks < ActiveRecord::Migration[5.1]
  def change
    create_table :checks do |t|
      t.date :date
      t.string :passed

      t.timestamps
    end
  end
end
