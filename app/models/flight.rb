class Flight < ApplicationRecord
   belongs_to :airline
   has_many :flight_passengers
   has_many :passengers, through: :flight_passengers

   def self.with_airline_and_passengers
      joins(:airline, :passengers)
        .select('flights.*, airlines.name as airline_name, flight_passengers.passenger_id as passenger_id, passengers.name as passenger_name')
        .group_by(&:id)
    end

    def remove_passenger(passenger)
      flight_passengers.find_by(passenger_id: passenger.id).destroy
    end
end