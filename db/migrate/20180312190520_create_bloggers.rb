class CreateBloggers < ActiveRecord::Migration[5.1]
  def change
    create_table :bloggers do |t|
      t.integer :blogger_id
      t.date :deadline
      t.date :reminded
      t.boolean :needsreminder

      t.timestamps
    end
  end
end
