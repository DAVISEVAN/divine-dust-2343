require "rails_helper"

RSpec.describe Airline, type: :model do
  describe 'relationships' do
    it { should have_many(:flights) }
    it { should have_many(:flight_passengers).through(:flights) }
    it { should have_many(:passengers).through(:flight_passengers) }
  end

  describe '#adult_passengers' do
    before :each do
      @airline1 = Airline.create!(name: "Frontier")
      @airline2 = Airline.create!(name: "Delta")

      @flight1 = @airline1.flights.create!(number: "1727", date: "01/15/24", departure_city: "Gotham", arrival_city: "Metropolis")
      @flight2 = @airline1.flights.create!(number: "1828", date: "02/20/24", departure_city: "Hogsmeade", arrival_city: "Hogwarts")
      @flight3 = @airline2.flights.create!(number: "1938", date: "03/25/24", departure_city: "Springfield", arrival_city: "Shelbyville")

      @passenger1 = Passenger.create!(name: "Joe Exotic", age: 57)
      @passenger2 = Passenger.create!(name: "Mary Poppins", age: 30)
      @passenger3 = Passenger.create!(name: "Walter White", age: 52)
      @passenger4 = Passenger.create!(name: "John Wick", age: 45)
      @passenger5 = Passenger.create!(name: "Little Kid", age: 10)
      @passenger6 = Passenger.create!(name: "Teen Kid", age: 17)

      FlightPassenger.create!(flight: @flight1, passenger: @passenger1)
      FlightPassenger.create!(flight: @flight1, passenger: @passenger2)
      FlightPassenger.create!(flight: @flight1, passenger: @passenger5)
      FlightPassenger.create!(flight: @flight2, passenger: @passenger1)
      FlightPassenger.create!(flight: @flight2, passenger: @passenger3)
      FlightPassenger.create!(flight: @flight3, passenger: @passenger4)
      FlightPassenger.create!(flight: @flight3, passenger: @passenger6)
    end

    it 'returns unique adult passengers for the airline' do
      expect(@airline1.adult_passengers).to match_array([@passenger1, @passenger2, @passenger3])
      expect(@airline1.adult_passengers).not_to include(@passenger4)
      expect(@airline1.adult_passengers).not_to include(@passenger5)
      expect(@airline1.adult_passengers).not_to include(@passenger6)
    end

    it 'does not include passengers from other airlines' do
      expect(@airline1.adult_passengers).not_to include(@passenger4)
    end

    it 'does not include duplicate passengers' do
      passengers = @airline1.adult_passengers
      expect(passengers).to eq(passengers.uniq)
    end
  end
end
