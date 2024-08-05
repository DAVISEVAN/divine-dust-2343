class FlightsController < ApplicationController
  def index
    @flights = Flight.with_airline_and_passengers
  end
end