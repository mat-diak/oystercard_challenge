require 'oystercard'

describe Oystercard do
    
    
    # check if Oystercard has all the methods
    it { is_expected.to respond_to(:top_up).with(1).argument}
    it { is_expected.to respond_to(:touch_out, :touch_in, :entry_station, :balance)}
    it { is_expected.not_to respond_to(:deduct) }
    
    let(:card) { Oystercard.new } # at this stage card does not exist it only saves a block to execute when card is called
    let(:station) { double() } #creaing a station 
   
    context 'at start-up'do
        it 'sets balance to 0' do 
            expect(card.balance).to eq 0
        end 
        it 'not in_journey' do
            expect(card).not_to be_in_journey
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

    # describe '#deduct' do

    #     context "when their is suffecient balance" do
    #         it 'deduct £50' do 
    #             expect { card.deduct(50) }.to change(card, :balance).by(-50)
    #         end 
    #     end
    # end

    describe '#touch_in' do
        context 'when the balance is at least 1' do
            it 'changes in journey to true' do 
                #arrange
                card.top_up(1)
                #act
                card.touch_in(station)
                #assert
                expect(card).to be_in_journey
            end 
            it 'stores the entry station' do
                #Arrage
                card.top_up(20)
                #act
                card.touch_in(station)
                #assert
                expect(card.entry_station).to eq(station)
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
            card.touch_out
            expect(card).not_to be_in_journey
        end 

        it 'sets entry_station to nil' do
            #Arrange
            card.top_up(20)
            #act
            card.touch_in(station)
            card.touch_out
            #assert
            expect(card.entry_station).to eq nil
        end

        it 'deducts minimum fare' do
            #Arrange
            # create a scenario
            card.top_up(1)
            card.touch_in(station)
            #Assert (here act is card.touch_in)
            expect { card.touch_out }.to change(card, :balance).by(-Oystercard::MINIMUM_FARE )
        end
    end 

    describe '#in_journey?' do
        # when @entry_station isn't nil, we want @journey_status to be true
        # arrange
        # we want touch_in(station) to alter journey_status

        #act

        #assert
    end
end

