airline = Airline.create!(name: "Frontier")

flight1 = airline.flights.create!(number: "1727", date: "01/15/24", departure_city: "Gotham", arrival_city: "Metropolis")
flight2 = airline.flights.create!(number: "1828", date: "02/20/24", departure_city: "Hogsmeade", arrival_city: "Hogwarts")

passenger1 = Passenger.create!(name: "Joe Exotic", age: 57)
passenger2 = Passenger.create!(name: "Mary Poppins", age: 30)
passenger3 = Passenger.create!(name: "Walter White", age: 52)
passenger4 = Passenger.create!(name: "John Wick", age: 45)
passenger5 = Passenger.create!(name: "Little Kid", age: 10)

FlightPassenger.create!(flight: flight1, passenger: passenger1)
FlightPassenger.create!(flight: flight1, passenger: passenger2)
FlightPassenger.create!(flight: flight1, passenger: passenger3)
FlightPassenger.create!(flight: flight2, passenger: passenger2)
FlightPassenger.create!(flight: flight2, passenger: passenger3)
FlightPassenger.create!(flight: flight2, passenger: passenger4)
FlightPassenger.create!(flight: flight2, passenger: passenger5)