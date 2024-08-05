class Flight < ApplicationRecord
   belongs_to :airline
   has_many :flight_passengers
   has_many :passengers, through: :flight_passengers

   def self.with_airline_and_passengers
      joins(:airline, :passengers)
        .select('flights.id, flights.number, airlines.name as airline_name, passengers.name as passenger_name')
        .group_by(&:id)
    end
end