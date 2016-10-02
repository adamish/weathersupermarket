class CreateMeta < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :name
    end


    create_table :locations do |t|
      t.belongs_to :provider
      t.datetime :last_fetch
      t.string :name
      t.string :token
      t.timestamps
    end
    add_index(:locations, [:provider_id, :token], :unique => true)

    create_table :searches do |t|
      t.string :search
      t.timestamps
    end

    create_table :search_results do |t|
      t.belongs_to :location
      t.belongs_to :search
      t.timestamps
    end

    create_table :quicklinks do |t|
      t.string :quicklink
      t.timestamps
    end
    
    create_table :quicklink_locations do |t|
      t.belongs_to :location
      t.belongs_to :quicklink
      t.timestamps
    end
    
    add_index(:quicklinks, [:quicklink], :unique => true)

  end
end
