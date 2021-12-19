require 'journey'

describe Journey do

  let(:journey) { Journey.new }
  let(:entry_station) { double(:entry_station) }
  let(:exit_station)  { double(:exit_station) }

  context 'when instantiated' do
    it { is_expected.to respond_to(:log) }
    it { is_expected.to respond_to(:begin_at, :finish_at).with(1).argument }

    it 'has an @history hash' do
      expect(journey.log).to eq ({})
    end
  end
  
  describe '#begin_at' do
    it 'adds entry station to history' do
      journey.begin_at(entry_station)
      expect(journey.log).to include ({
          from: entry_station
      })
    end
  end
    
  describe '#finish_at' do
    it 'adds exit station to history' do
      journey.finish_at(exit_station)
      expect(journey.log).to include ({
          to: exit_station
      })
    end
  end
end