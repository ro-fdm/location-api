class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :phone
      t.string :address
      t.string :postcode
      t.string :city
      t.string :country

      t.timestamps
    end
  end
end
