require 'oystercard'

describe Oystercard do
    
    describe 'methods' do
        it { is_expected.to respond_to(:top_up).with(1).argument}
        it { is_expected.to respond_to(:touch_out, :touch_in, :entry_station, :balance)}
        it { is_expected.not_to respond_to(:deduct) }
    end

    let(:card) { Oystercard.new } 
    let(:station) { double(:station) }
   
    context 'at start-up'do
        it 'sets balance to 0' do 
            expect(card.balance).to eq 0
        end 
        it 'not in_journey' do
            expect(card).not_to be_in_journey
        end
        it 'has an empty journey history hash' do
            expect(card.journey_history).to eq ({}) # be_empty 
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
                card.top_up(Oystercard::MINIMUM_FARE)
                card.touch_in(station)
                expect(card).to be_in_journey
            end 
            it 'stores the entry station' do
                card.top_up(20)
                card.touch_in(station)
                expect(card.entry_station).to eq(station)
            end

            it 'checks if entry_station is added to jounrey_history' do
                card.top_up(1)
                card.touch_in(station)
                expect(card.journey_history).to include ({
                    entry_st: station,
                })
            end

        end
        context 'when balance is 0' do
            it 'throws an error' do
                expect { card.touch_in(station) }.to raise_error "Insufficient balance."
            end
        end
    end 

    describe '#touch_out' do
        it 'changes in_journey to false' do 
            card.touch_out(station)
            expect(card).not_to be_in_journey
        end 

        it 'sets entry_station to nil' do
            card.top_up(20)
            card.touch_in(station)
            card.touch_out(station)
            expect(card.entry_station).to eq nil
        end

        it 'deducts minimum fare' do
            card.top_up(1)
            card.touch_in(station)
            expect { card.touch_out(station) }.to change(card, :balance).by(-Oystercard::MINIMUM_FARE )
        end

        it 'stores the exit station' do
            card.top_up(20)
            card.touch_in(station)
            card.touch_out(station)
            expect(card.exit_station).to eq(station)
        end

        it 'checks if exit_station is added to jounrey_history' do
            card.top_up(1)
            card.touch_in(station)
            card.touch_out(station)
            expect(card.journey_history).to include ({
                entry_st: station,
                exit_st: station
            })
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
    
    # let(:journey) { 
    #     card.top_up(1)
    #     card.touch_in(station)
    #     card.touch_out(station) 
    # }

    # describe '#journey_history_list' do
    #     it 'add journey to journey_history'
    #     2.times { journey }
    #     expect(card.journey_history_list).to eq ({
    #         1 => [station, station],
    #         2 => [station, station]
    #     })
    # end
end




# I wanna see journey history

# Journey_history array [[entry, exit], [entry, exit]]
# 0 [], 1 []