class CreateFlightPassengers < ActiveRecord::Migration[7.1]
  def change
    create_table :flight_passengers do |t|
      t.references :flight, null: false, foreign_key: true
      t.references :passenger, null: false, foreign_key: true

      t.timestamps
    end
  end
end
