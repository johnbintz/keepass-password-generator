require 'set'

module KeePass
  
  module Password

    class InvalidCharSetIDError < RuntimeError; end
  
    # Character sets for the KeePass password generator.
    #
    # @see http://keepass.info/help/base/pwgenerator.html#pattern
    class CharSet < Set

      UPPERCASE        = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      LOWERCASE        = "abcdefghijklmnopqrstuvwxyz"
      DIGITS           = "0123456789"
      UPPER_CONSONANTS = "BCDFGHJKLMNPQRSTVWXYZ"
      LOWER_CONSONANTS = "bcdfghjklmnpqrstvwxyz"
      UPPER_VOWELS     = "AEIOU"
      LOWER_VOWELS     = "aeiou"
      PUNCTUATION      = ",.;:"
      BRACKETS         = "[]{}()<>"
      PRINTABLE_ASCII_SPECIAL = "!\"#\$%&'()*+,-./:;<=>?[\\]^_{|}~"
      UPPER_HEX        = "0123456789ABCDEF"
      LOWER_HEX        = "0123456789abcdef"
      HIGH_ANSI        = (0x7f..0xfe).map { |i| i.chr }.join
  
      DEFAULT_MAPPING = {
        'a' => [LOWERCASE, DIGITS],
        'A' => [LOWERCASE, UPPERCASE, DIGITS],
        'U' => [UPPERCASE, DIGITS],
        'c' => [LOWER_CONSONANTS],
        'C' => [LOWER_CONSONANTS, UPPER_CONSONANTS],
        'z' => [UPPER_CONSONANTS],
        'd' => [DIGITS],
        'h' => [LOWER_HEX],
        'H' => [UPPER_HEX],
        'l' => [LOWERCASE],
        'L' => [LOWERCASE, UPPERCASE],
        'u' => [UPPERCASE],
        'p' => [PUNCTUATION],
        'b' => [BRACKETS],
        's' => [PRINTABLE_ASCII_SPECIAL],
        'S' => [UPPERCASE, LOWERCASE, DIGITS, PRINTABLE_ASCII_SPECIAL],
        'v' => [LOWER_VOWELS],
        'V' => [LOWER_VOWELS, UPPER_VOWELS],
        'Z' => [UPPER_VOWELS],
        'x' => [HIGH_ANSI],
      }
      
      ASCII_MAPPING = DEFAULT_MAPPING.reject { |k, v| k == 'x' }
      
      # @return [Hash] the KeePass character set ID mapping
      attr_accessor :mapping
      
      # Instantiates a new CharSet object.
      #
      # @see Set#new
      def initialize(*args)
        @mapping = DEFAULT_MAPPING
        super
      end

      # Adds several characters according to the KeePass character class.
      #
      # @see http://keepass.info/help/base/pwgenerator.html#pattern
      # @param [String] char_set_id the KeePass character set ID
      # @raise [InvalidCharSetIDError] if mapping does not contain `char_set_id`
      # @return [CharSet] self
      def add_from_char_set_id(char_set_id)
        if strings = mapping[char_set_id]
          add_from_strings *strings
        else
          raise InvalidCharSetIDError, "no such char set ID #{char_set_id.inspect}"
        end
      end
  
      # Adds each character from one or more strings.
      #
      # @param [Array] *strings one or more strings to add
      # @return [CharSet] self
      def add_from_strings(*strings)
        strings.each { |s| merge Set.new(s.split('')) }
        self
      end
  
    end

  end

end
