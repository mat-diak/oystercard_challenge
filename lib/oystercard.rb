require './lib/station'
require './lib/journey'

class Oystercard
    attr_reader :balance, :past_journeys, :current_journey

    LIMIT = 90
    MINIMUM_FARE = 1
    DEFAULT_BALANCE = 0

    def initialize(balance = DEFAULT_BALANCE)
        @balance = balance
        @past_journeys = []
    end

    def top_up(amount)
        (@balance + amount) > LIMIT ? fail("Balance cannot exceed £#{LIMIT}.") : @balance += amount
    end 

    def touch_in(station)
        raise "Insufficient balance." unless @balance >= MINIMUM_FARE
        @current_journey = Journey.new
        @current_journey.begin_at(station)
    end 
    
    def touch_out(station)
        deduct(MINIMUM_FARE)
        @current_journey.finish_at(station)
        @past_journeys << @current_journey.log
        @current_journey = nil
    end
    
    def in_journey?
        return true unless @current_journey == nil
        false
    end 

    private
    
    def deduct(amount)
        @balance -= amount
    end
    
end