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
        
        # @entry_station = nil
        # @journey_history = {}
        # @journey_history_list = {}
    end

    def top_up(amount)
        (@balance + amount) > LIMIT ? fail("Balance cannot exceed £#{LIMIT}.") : @balance += amount
    end 

    def touch_in(station)
        raise "Insufficient balance." unless @balance >= MINIMUM_FARE
        @current_journey = Journey.new
        @current_journey.begin_at(station)
        # @entry_station = station
        # @journey_history.store(:entry_st, station)
    end 
    
    def touch_out(station)
        deduct(MINIMUM_FARE)
        @current_journey.finish_at(station)
        @past_journeys << @current_journey.log
        @current_journey = nil
        # @exit_station = station
        # @journey_history.store(:exit_st, station)
        # # @journey_history_list[journey_counter + 1] = @journey_history
        # @entry_station = nil
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