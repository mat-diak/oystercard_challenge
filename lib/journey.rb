class Journey 
  attr_reader :history

  def initialize
    @history = {}
  end

  def in_journey?
    return true unless @entry_station == nil
    false
  end 

  def begin_at(station)
    @entry_station = station
    @history.store(:from, station)
  end

  def finish_at(station)
    @history.store(:to, station)
  end
end