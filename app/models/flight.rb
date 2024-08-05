class Flight < ApplicationRecord
   belongs_to :airline
   has_many :flight_passengers
   has_many :passengers, through: :flight_passengers

   def self.with_airline_and_passengers
      joins(:airline, :passengers)
        .select('flights.*, airlines.name as airline_name, flight_passengers.passenger_id as passenger_id, passengers.name as passenger_name')
        .group_by(&:id)
        .transform_values do |records|
          flight = records.first
          {
            flight: flight,
            passengers: records.map { |r| { name: r.passenger_name, id: r.passenger_id } }
          }
        end
    end

    def remove_passenger(passenger)
      flight_passengers.find_by(passenger_id: passenger.id).destroy
    end
end