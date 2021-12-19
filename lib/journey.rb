class Journey 
  attr_reader :log

  #we want to store the beginning station at creation of
  def initialize
    @log = {}
  end

  def begin_at(station)
    @entry_station = station
    @log.store(:from, station)
  end

  def finish_at(station)
    @log.store(:to, station)
  end
end
