class AddErrorToLocations < ActiveRecord::Migration[5.1]
  def change
    add_column :locations, :error, :string
  end
end
