class AddStatusToLocations < ActiveRecord::Migration[5.1]
  def change
    add_column :locations, :status, :string
  end
end
