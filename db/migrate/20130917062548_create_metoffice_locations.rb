class CreateMetofficeLocations < ActiveRecord::Migration
  def change
    create_table :metoffice_locations do |t|
      t.string :name
      t.string :name_lower
      t.string :token

      t.timestamps
    end
    
    add_index(:metoffice_locations, [:name_lower])
  end
end
