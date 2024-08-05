require 'rails_helper'

RSpec.describe 'Remove Passenger from Flight', type: :feature do
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
    FlightPassenger.create!(flight: @flight2, passenger: @passenger1)
    FlightPassenger.create!(flight: @flight2, passenger: @passenger2)
    FlightPassenger.create!(flight: @flight2, passenger: @passenger3)
    FlightPassenger.create!(flight: @flight2, passenger: @passenger4)
    FlightPassenger.create!(flight: @flight2, passenger: @passenger5)
  end

  it 'removes a passenger from a flight' do
    visit flights_path

    within("#flight-#{@flight1.id}") do
      expect(page).to have_content(@passenger1.name)
      click_link 'Remove', match: :first
    end

    expect(current_path).to eq(flights_path)

    within("#flight-#{@flight1.id}") do
      expect(page).to_not have_content(@passenger1.name)
    end

    within("#flight-#{@flight2.id}") do
      expect(page).to have_content(@passenger1.name)
    end
  end
end
