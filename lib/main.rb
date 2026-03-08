class Package
  BULKY_VOLUME_THRESHOLD = 1_000_000
  BULKY_DIMENSION_THRESHOLD = 150
  HEAVY_MASS_THRESHOLD = 20

  def initialize(width:, height:, length:, mass:)
    @width = width
    @height = height
    @length = length
    @mass = mass
  end

  def bulky?
    volume >= BULKY_VOLUME_THRESHOLD || oversized_dimension?
  end

  def heavy?
    mass >= HEAVY_MASS_THRESHOLD
  end

  private

  attr_reader :width, :height, :length, :mass

  def volume
    width * height * length
  end

  def oversized_dimension?
    [width, height, length].any? { |dimension| dimension >= BULKY_DIMENSION_THRESHOLD }
  end
end

class PackageSorter
  STANDARD = "STANDARD".freeze
  SPECIAL  = "SPECIAL".freeze
  REJECTED = "REJECTED".freeze

  def self.sort(width, height, length, mass)
    validate_args!(width, height, length, mass)
    package = Package.new(width: width, height: height, length: length, mass: mass)
    new(package).sort
  end

  def initialize(package)
    @package = package
  end

  def sort
    return REJECTED if rejected?
    return SPECIAL if special?

    STANDARD
  end

  private

  attr_reader :package

  def self.validate_args!(*args)
    names = %i[width height length mass]
    names.zip(args).each do |name, value|
      raise ArgumentError, "All inputs must be positive numbers" unless value.is_a?(Numeric) && value.positive?
    end
  end

  private_class_method :validate_args!

  def rejected?
    package.bulky? && package.heavy?
  end

  def special?
    package.bulky? || package.heavy?
  end
end

def sort(width, height, length, mass)
  PackageSorter.sort(width, height, length, mass)
end
