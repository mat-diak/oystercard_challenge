require 'oystercard'

describe Oystercard do
  
  describe 'methods' do
    it { is_expected.to respond_to(:top_up).with(1).argument}
    it { is_expected.to respond_to(:create_journey).with(2).arguments}
    it { is_expected.to respond_to(:touch_out, :touch_in, :balance, :close_journey)}
    it { is_expected.not_to respond_to(:deduct) }
  end

  let(:card) { Oystercard.new } 
  let(:station) { double(:station) }
  let(:entry_station) { double(:entry_station) } 
  let(:exit_station) { double(:exit_station) } 


  context 'at start-up'do
    it 'sets balance to 0' do 
      expect(card.balance).to eq 0
    end 
    it 'has @past_journeys of empty []' do 
        expect(card.past_journeys).to eq ([])
    end
  end

  describe '#top_up' do
    it 'adds 5 to balance' do 
      expect { card.top_up(5) }.to change(card, :balance).by(5)
    end 

    it 'adds 90 to balance' do
      expect(card.top_up(90)).to eq 90
    end 
  end   
  
  describe '#top_up limit' do
    context "when balance is above limit" do
      it 'returns error' do
        card.top_up(90)
        expect{card.top_up(5)}.to raise_error("Balance cannot exceed £#{Oystercard::LIMIT}.")
      end 
    end
  end

  describe '#touch_in' do
    context 'when the balance is at least 1' do
      it 'changes in journey to true' do 
        card.top_up(Journey::MINIMUM_FARE)
        card.touch_in(entry_station)
        expect(card).to be_in_journey
      end 
    end

    context 'when balance is 0' do
      it 'throws an error' do
        expect { card.touch_in(station) }.to raise_error "Insufficient balance."
      end
    end

    context 'when touch out missed on previous journey' do
      it 'deducts maximum fare' do
        card.top_up(10)
        card.touch_in(entry_station)
        expect { card.touch_in(entry_station) }.to change(card, :balance).by(-Journey::MAXIMUM_FARE)
      end
    end
  end 

  describe '#touch_out' do
		context 'after a complete journey' do
			before (:each) do
				card.top_up(20)
      	card.touch_in(entry_station)
      	card.touch_out(exit_station)
			end

			it 'changes in_journey to false' do 
				expect(card).not_to be_in_journey
			end 

			it 'sets @current_journey to nil' do
				expect(card.current_journey).to eq nil
			end

			it 'adds @current_journey to @past_journeys' do
				expect(card.past_journeys).to include ({ from: entry_station, to: exit_station })
			end
		end

		context 'when entry and exit present' do
			it 'deducts minimum fare' do
				card.top_up(1) 
				card.touch_in(entry_station)
				expect { card.touch_out(exit_station) }.to change(card, :balance).by(-Journey::MINIMUM_FARE )
			end
		end

		context 'when touching out with no entry' do
			it 'deducts maximum fare' do
				expect { card.touch_out(exit_station) }.to change(card, :balance).by(-Journey::MAXIMUM_FARE )
			end
		end
  end

  describe '#in_journey?' do
    context 'when entry station is nil' do
      it 'is false' do
        expect(card.in_journey?).to be false
      end
    end
    context 'when entry station is not nil' do
      it 'is true' do
        card.top_up(10)
        card.touch_in(station)
        expect(card.in_journey?).to be true
      end
    end
  end

  describe '#create_journey' do
    it 'creates a journey' do
      card.create_journey(entry_station, exit_station)
      expect(card.current_journey).to be_a Journey
    end
  end
end