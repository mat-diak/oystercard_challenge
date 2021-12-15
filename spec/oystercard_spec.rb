require 'oystercard'

describe Oystercard do
    
    # check if Oystercard has all the methods
    it { is_expected.to respond_to(:top_up).with(1).argument}
    it { is_expected.to respond_to(:deduct, :touch_out, :touch_in)}
   
    let(:card) { Oystercard.new }
   
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

    describe '#deduct' do

        context "when their is suffecient balance" do
            it 'deduct £50' do 
                expect { card.deduct(50) }.to change(card, :balance).by(-50)
            end 
        end
    end

    describe '#touch_in' do
        context 'when the balance is at least 1' do
            it 'changes in journey to true' do 
                card.top_up(1)
                card.touch_in
                expect(card).to be_in_journey
            end 
        end
        context 'when balance is 0' do
            it 'throws an error' do
                expect { card.touch_in }.to raise_error "Insufficient balance."
            end
        end
    end 

    describe '#touch_out' do
        it 'changes in_journey to false' do 
            card.touch_out
            expect(card).not_to be_in_journey
        end 
    end 
end
