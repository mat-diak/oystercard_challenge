require 'journey'

describe Journey do

  let(:journey) { Journey.new }
  let(:station) { double(:station) }

  context 'when instantiated' do
    it { is_expected.to respond_to(:history, :in_journey?) }
    it { is_expected.to respond_to(:begin_at, :finish_at).with(1).argument }

    it 'has an @history hash' do
      expect(journey.history).to eq ({})
    end

    it 'is not in journey' do
      expect(journey).not_to be_in_journey
    end
  end
  
  describe '#begin_at' do
    it 'adds entry station to history' do
      journey.begin_at(station)
      expect(journey.history).to include ({
          from: station
      })
    end
  end
    
  describe '#finish_at' do
    it 'adds exit station to history' do
      journey.finish_at(station)
      expect(journey.history).to include ({
          to: station
      })
    end
  end
end