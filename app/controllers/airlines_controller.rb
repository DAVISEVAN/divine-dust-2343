class AirlinesController < ApplicationController
  def show
    @airline = Airline.find(params[:id])
    @adult_passengers = @airline.adult_passengers
  end
end
