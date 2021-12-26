class Journey 
  attr_reader :log

  MINIMUM_FARE, MAXIMUM_FARE = 1, 6

  def initialize(entry_station = nil, exit_station = nil)
    @log = {from: entry_station, to: exit_station}
  end

  def begin_at(entry_station)
    @log.store(:from, entry_station)
  end

  def finish_at(exit_station)
    @log.store(:to, exit_station)
  end

  def fare
    @log.has_value?(nil) ? MAXIMUM_FARE : MINIMUM_FARE
  end
end
