require 'airport'
require 'plane'

describe Airport do

  let(:plane) { double("plane", :in_air => true) } #sets a double with instance variable in_air
  let(:plane_grounded) { double("plane", :in_air => false) }
  let(:grounded) { allow(plane).to receive(:grounded) } #allows plane double to use grounded method
  let(:clear) { allow(subject).to receive(:weather_check).and_return true }
  let(:stormy) { allow(subject).to receive(:weather_check).and_return false }

  it 'Should have an airport class' do
    expect(subject).to be_instance_of(Airport)
  end

  it 'Should have a defualt capacity' do
    expect(subject.capacity).to eq(10)
  end

  it 'Should be able to have a defualt capacity set' do
    expect(Airport.new(100).capacity).to eq(100)
  end

  describe '#land' do
    it 'Should #land a plane in the airport' do
      grounded
      clear
      expect(subject.land(plane)).to include(plane)
    end

    it 'Should not let a plane land if airport is full' do
      grounded
      clear
      10.times { subject.land(plane) }
      expect { subject.land(plane) }.to raise_error("Airport full")
    end

    it 'Should not let a plane land in a storm,' do
      stormy
      expect { subject.land(plane) }.to raise_error("You must wait due to a storm")
    end

    it 'Should not let a plane land if it is not in the air' do
      expect { subject.land(plane_grounded) }.to raise_error('This plane is not in the air')
    end
  end

  describe '#take_off' do
    it 'Should not let a plane take off that is not in the hanger' do
      clear
      expect { subject.take_off(plane) }.to raise_error("this plane is not in the hanger")
    end

    it 'Should remove a plane for the hanger on takeoff' do
      grounded
      clear
      subject.land(plane)
      subject.take_off(plane)
      expect(subject.hanger).not_to include(plane)
    end

    it 'Should not let a plane takeoff in a storm,' do
      stormy
      expect { subject.take_off(plane)}.to raise_error("You must wait due to a storm")
    end
  end

  describe '#weather_check' do
    it 'Should respond to #weather_check' do
      expect(subject).to respond_to(:weather_check)
    end

    it 'Should return a true' do
      clear
      expect(subject.weather_check).to eq true
    end
  end
end
