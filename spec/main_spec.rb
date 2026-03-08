require_relative "../lib/main"

RSpec.describe Package do
  describe "#bulky?" do
    context "when volume is below threshold and no dimension is oversized" do
      it "is false" do
        package = described_class.new(width: 10, height: 10, length: 10, mass: 5)
        expect(package.bulky?).to be(false)
      end
    end

    context "when volume is exactly at threshold" do
      it "is true" do
        package = described_class.new(width: 100, height: 100, length: 100, mass: 5)
        expect(package.bulky?).to be(true)
      end
    end

    context "when volume exceeds threshold" do
      it "is true" do
        package = described_class.new(width: 101, height: 100, length: 100, mass: 5)
        expect(package.bulky?).to be(true)
      end
    end

    context "when one dimension is exactly at threshold" do
      it "is true" do
        package = described_class.new(width: 150, height: 10, length: 10, mass: 5)
        expect(package.bulky?).to be(true)
      end
    end

    context "when one dimension exceeds threshold" do
      it "is true" do
        package = described_class.new(width: 151, height: 10, length: 10, mass: 5)
        expect(package.bulky?).to be(true)
      end
    end
  end

  describe "#heavy?" do
    context "when mass is below threshold" do
      it "is false" do
        package = described_class.new(width: 10, height: 10, length: 10, mass: 19.9)
        expect(package.heavy?).to be(false)
      end
    end

    context "when mass is exactly at threshold" do
      it "is true" do
        package = described_class.new(width: 10, height: 10, length: 10, mass: 20)
        expect(package.heavy?).to be(true)
      end
    end

    context "when mass exceeds threshold" do
      it "is true" do
        package = described_class.new(width: 10, height: 10, length: 10, mass: 25)
        expect(package.heavy?).to be(true)
      end
    end
  end
end

RSpec.describe PackageSorter do
  describe ".sort" do
    context "when package is neither bulky nor heavy" do
      it "returns STANDARD" do
        package = instance_double(Package, bulky?: false, heavy?: false)
        allow(Package).to receive(:new).and_return(package)
        expect(described_class.sort(1, 2, 3, 4)).to eq("STANDARD")
      end
    end

    context "when package is heavy only" do
      it "returns SPECIAL" do
        package = instance_double(Package, bulky?: false, heavy?: true)
        allow(Package).to receive(:new).and_return(package)
        expect(described_class.sort(1, 2, 3, 4)).to eq("SPECIAL")
      end
    end

    context "when package is bulky only" do
      it "returns SPECIAL" do
        package = instance_double(Package, bulky?: true, heavy?: false)
        allow(Package).to receive(:new).and_return(package)
        expect(described_class.sort(1, 2, 3, 4)).to eq("SPECIAL")
      end
    end

    context "when package is both bulky and heavy" do
      it "returns REJECTED" do
        package = instance_double(Package, bulky?: true, heavy?: true)
        allow(Package).to receive(:new).and_return(package)
        expect(described_class.sort(1, 2, 3, 4)).to eq("REJECTED")
      end
    end
  end
end

RSpec.describe "top-level sort" do
  it "returns STANDARD when neither bulky nor heavy" do
    expect(sort(10, 10, 10, 5)).to eq("STANDARD")
  end

  it "returns SPECIAL when heavy only" do
    expect(sort(10, 10, 10, 20)).to eq("SPECIAL")
  end

  it "returns SPECIAL when bulky only (volume threshold)" do
    expect(sort(100, 100, 100, 5)).to eq("SPECIAL")
  end

  it "returns SPECIAL when bulky only (dimension threshold)" do
    expect(sort(150, 10, 10, 5)).to eq("SPECIAL")
  end

  it "returns REJECTED when both bulky and heavy" do
    expect(sort(100, 100, 100, 20)).to eq("REJECTED")
  end

  context "with invalid inputs" do
    it "raises ArgumentError when any dimension is zero or negative" do
      expect { sort(0, 10, 10, 5) }.to raise_error(ArgumentError)
      expect { sort(-1, 10, 10, 5) }.to raise_error(ArgumentError)
    end

    it "raises ArgumentError when mass is zero or negative" do
      expect { sort(10, 10, 10, 0) }.to raise_error(ArgumentError)
      expect { sort(10, 10, 10, -0.1) }.to raise_error(ArgumentError)
    end
  end
end
