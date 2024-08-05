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

    it 'returns flights with their airline name and passenger names' do
      flights_with_details = Flight.with_airline_and_passengers

      flight1_data = flights_with_details[@flight1.id]
      flight2_data = flights_with_details[@flight2.id]
      flight3_data = flights_with_details[@flight3.id]

      expect(flight1_data[:flight].number).to eq(@flight1.number)
      expect(flight1_data[:flight].airline_name).to eq(@airline1.name)
      passenger_names_flight1 = flight1_data[:passengers].map { |p| p[:name] }
      expect(passenger_names_flight1).to include(@passenger1.name)
      expect(passenger_names_flight1).to include(@passenger2.name)
      expect(passenger_names_flight1).to include(@passenger5.name)

      expect(flight2_data[:flight].number).to eq(@flight2.number)
      expect(flight2_data[:flight].airline_name).to eq(@airline1.name)
      passenger_names_flight2 = flight2_data[:passengers].map { |p| p[:name] }
      expect(passenger_names_flight2).to include(@passenger1.name)
      expect(passenger_names_flight2).to include(@passenger3.name)

      expect(flight3_data[:flight].number).to eq(@flight3.number)
      expect(flight3_data[:flight].airline_name).to eq(@airline2.name)
      passenger_names_flight3 = flight3_data[:passengers].map { |p| p[:name] }
      expect(passenger_names_flight3).to include(@passenger4.name)
      expect(passenger_names_flight3).to include(@passenger6.name)
    end
  end

  describe '#remove_passenger' do
    before :each do
      @airline1 = Airline.create!(name: "Frontier")
      @flight1 = @airline1.flights.create!(number: "1727", date: "01/15/24", departure_city: "Gotham", arrival_city: "Metropolis")
      @passenger1 = Passenger.create!(name: "Joe Exotic", age: 57)
      FlightPassenger.create!(flight: @flight1, passenger: @passenger1)
    end

    it 'removes a passenger from a flight' do
      expect(@flight1.passengers).to include(@passenger1)
      @flight1.remove_passenger(@passenger1)
      expect(@flight1.passengers).to_not include(@passenger1)
    end
  end
end