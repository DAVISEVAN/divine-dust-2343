require 'rails_helper'

RSpec.describe 'Airline Show Page', type: :feature do
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

  it 'shows a list of unique adult passengers for that airline' do
    visit airline_path(@airline1)

    expect(page).to have_content("Joe Exotic (Age: 57)")
    expect(page).to have_content("Mary Poppins (Age: 30)")
    expect(page).to have_content("Walter White (Age: 52)")
    expect(page).to_not have_content("John Wick (Age: 45)")
    expect(page).to_not have_content("Little Kid (Age: 10)")
    expect(page).to_not have_content("Teen Kid (Age: 17)")
  end
end
