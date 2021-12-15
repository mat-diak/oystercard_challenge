class Oystercard
    attr_reader :balance, :journey_status

    LIMIT = 90
    MINIMUM_FARE = 1
    def initialize(balance = 0)
        @balance = balance
        @journey_status = false
    end

    def top_up(amount)
        (balance + amount) > LIMIT ? fail("Balance cannot exceed £#{LIMIT}.") : @balance += amount
    end 

    def deduct(amount)
        @balance -= amount
    end
        
    def touch_in
        # I want an error when balance is less than 1 else change journey status
        raise "Insufficient balance." unless @balance >= MINIMUM_FARE
        @journey_status = true 
    end 

    def touch_out
        @journey_status = false

    end

    def in_journey?
        @journey_status
    end 
end