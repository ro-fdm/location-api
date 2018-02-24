class AddLatitudeLongitudeToLocations < ActiveRecord::Migration[5.1]
  def change
    add_column :locations, :latitude, :decimal, precision: 11, scale: 7
    add_column :locations, :longitude, :decimal, precision: 11, scale: 7
  end
end
