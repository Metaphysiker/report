class AddInterestsToBloggers < ActiveRecord::Migration[5.1]
  def change
    add_column :bloggers, :interests, :string
  end
end
