class AddBeginningToBloggers < ActiveRecord::Migration[5.1]
  def change
    add_column :bloggers, :beginning, :date
  end
end
