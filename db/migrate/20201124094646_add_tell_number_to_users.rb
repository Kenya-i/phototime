class AddTellNumberToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :tell_number, :string
  end
end
