require './lib/station'
require './lib/journey'

class Oystercard
  attr_reader :balance, :past_journeys, :current_journey

  LIMIT = 90
  DEFAULT_BALANCE = 0

  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance
    @past_journeys = []
  end

  def top_up(amount)
    (@balance + amount) > LIMIT ? fail("Balance cannot exceed £#{LIMIT}.") : @balance += amount
  end 

  def touch_in(entry_station)
    close_journey if in_journey?
    raise "Insufficient balance." unless @balance >= Journey::MINIMUM_FARE
    create_journey(entry_station)
  end 

  def touch_out(exit_station)
    in_journey? ? @current_journey.finish_at(exit_station) : create_journey(nil, exit_station)
    close_journey
  end

  def in_journey?
    return true unless @current_journey == nil
    false
  end 
  
  def archive_journey
    @past_journeys << @current_journey.log
    @current_journey = nil
  end
  
  def create_journey(entry_station = nil, exit_station = nil)
    @current_journey = Journey.new(entry_station, exit_station)
  end

  def close_journey
    deduct(@current_journey.fare)
    archive_journey
  end
  
  private

  def deduct(amount)
    @balance -= amount
  end 
end