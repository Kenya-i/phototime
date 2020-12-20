class RemoveSexFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :sex, :boolean
  end
end
