module Fitreader
  class DataField < FitObject
    TYPES = {
        0 => {size: 1, unpack_type: 'C', endian: 0, invalid: 255},
        1 => {size: 1, unpack_type: 'c', endian: 0, invalid: 127},
        2 => {size: 1, unpack_type: 'C', endian: 0, invalid: 255},
        3 => {size: 2, unpack_type: {big: 's>', little: 's<'}, endian: 1, invalid: 32767},
        4 => {size: 2, unpack_type: {big: 'S>', little: 'S<'}, endian: 1, invalid: 65535},
        5 => {size: 4, unpack_type: {big: 'l>', little: 'l<'}, endian: 1, invalid: 2147483647},
        6 => {size: 4, unpack_type: {big: 'L>', little: 'L<'}, endian: 1, invalid: 4294967295},
        7 => {size: 1, unpack_type: 'Z*', endian: 0, invalid: 0},
        8 => {size: 4, unpack_type: {big: 'e', little: 'g'}, endian: 1, invalid: 4294967295},
        9 => {size: 8, unpack_type: {big: 'E', little: 'G'}, endian: 1, invalid: 18446744073709551615},
        10 => {size: 1, unpack_type: 'C', endian: 0, invalid: 0},
        11 => {size: 2, unpack_type: {big: 'S>', little: 'S<'}, endian: 1, invalid: 0},
        12 => {size: 4, unpack_type: {big: 'L>', little: 'L<'}, endian: 1, invalid: 0},
        13 => {size: 1, unpack_type: 'C', endian: 0, invalid: 0xFF},
        14 => {size: 8, unpack_type: {big: 'q>', little: 'q<'}, endian: 1, invalid: 0x7FFFFFFFFFFFFFFF},
        15 => {size: 8, unpack_type: {big: 'Q>', little: 'Q<'}, endian: 1, invalid: 0xFFFFFFFFFFFFFFFF},
        16 => {size: 8, unpack_type: nil, endian: 1, invalid: 0x0000000000000000}
    }.freeze

    attr_reader :raw, :valid

    def initialize(io, options)
      base_num = options[:base_num]
      size = options[:size]
      arch = options[:arch]

      base = TYPES[base_num]
      char = base[:unpack_type]
      char = char[arch] if char.is_a?(Hash)
      @raw = read_multiple(io, char, size, base[:size])
      @valid = check(@raw, base[:invalid])
    end

    def check(raw, invalid)
      if raw.is_a? Array
        raw.any? { |e| e != invalid }
      else
        raw != invalid
      end
    end
  end
end