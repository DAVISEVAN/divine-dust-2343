require "rails_helper"

RSpec.describe Flight, type: :model do
  describe 'relationships' do
    it { should belong_to(:airline) }
    it { should have_many(:flight_passengers) }
    it { should have_many(:passengers).through(:flight_passengers) }
  end

  describe '.with_airline_and_passengers' do
    before :each do
      @airline1 = Airline.create!(name: "Frontier")
      @airline2 = Airline.create!(name: "Delta")

      @flight1 = @airline1.flights.create!(number: "1727", date: "01/15/24", departure_city: "Gotham", arrival_city: "Metropolis")
      @flight2 = @airline2.flights.create!(number: "1828", date: "02/20/24", departure_city: "Hogsmeade", arrival_city: "Hogwarts")

      @passenger1 = Passenger.create!(name: "Joe Exotic", age: 57)
      @passenger2 = Passenger.create!(name: "Mary Poppins", age: 30)
      @passenger3 = Passenger.create!(name: "Walter White", age: 52)
      @passenger4 = Passenger.create!(name: "John Wick", age: 45)
      @passenger5 = Passenger.create!(name: "Little Kid", age: 10)

      FlightPassenger.create!(flight: @flight1, passenger: @passenger1)
      FlightPassenger.create!(flight: @flight1, passenger: @passenger2)
      FlightPassenger.create!(flight: @flight1, passenger: @passenger3)
      FlightPassenger.create!(flight: @flight1, passenger: @passenger5)
      FlightPassenger.create!(flight: @flight2, passenger: @passenger2)
      FlightPassenger.create!(flight: @flight2, passenger: @passenger3)
      FlightPassenger.create!(flight: @flight2, passenger: @passenger4)
      FlightPassenger.create!(flight: @flight2, passenger: @passenger5)
    end

    it 'returns flights with their airline name and passenger names' do
      flights = Flight.with_airline_and_passengers

      expect(flights.keys).to include(@flight1.id)
      expect(flights.keys).to include(@flight2.id)

      flight1_data = flights[@flight1.id]
      expect(flight1_data.first.number).to eq(@flight1.number)
      expect(flight1_data.first.airline_name).to eq(@airline1.name)
      expect(flight1_data.map(&:passenger_name)).to match_array(["Joe Exotic", "Mary Poppins", "Walter White", "Little Kid"])

      flight2_data = flights[@flight2.id]
      expect(flight2_data.first.number).to eq(@flight2.number)
      expect(flight2_data.first.airline_name).to eq(@airline2.name)
      expect(flight2_data.map(&:passenger_name)).to match_array(["Mary Poppins", "Walter White", "John Wick", "Little Kid"])
    end

    it 'removes a passenger from a flight' do
      expect(@flight1.passengers).to include(@passenger1)
      @flight1.remove_passenger(@passenger1)
      expect(@flight1.passengers).to_not include(@passenger1)
    end
  end
end
