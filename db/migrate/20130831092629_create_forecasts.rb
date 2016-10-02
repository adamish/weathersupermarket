class CreateForecasts < ActiveRecord::Migration
  def change
    create_table :forecasts do |t|
      t.datetime :date   # time of data
      t.string :daytime  # provider specific, e.g. 9:00, morning etc.

      t.string :summary # free text
      t.string :symbol  # rain, cloud etc.
      t.integer :temp_min  # degrees C
      t.integer :temp_max  # degrees C
      t.integer :wind_speed  # kph
      t.string :wind_dir  # 'N', 'S'
      t.string :link # URL to source data
      t.integer :stars # 1-5
      t.belongs_to :location

      t.timestamps
    end
    add_index(:forecasts, [:date])
    add_index(:forecasts, [:location_id])
  end


end
