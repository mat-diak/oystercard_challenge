require 'station'

describe Station do
  let(:station) { Station.new("name", 2) } 
  
  it 'returns name' do
    expect(station.name).to eq "name"
  end
 
  it 'returns zone' do
    expect(station.zone).to eq 2
  end

end

#We wanna test whether has a name and a zone