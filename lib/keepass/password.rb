require 'keepass/password/char_set'
require 'keepass/password/generator'
require 'keepass/password/version'

module KeePass
  
  module Password

    # Returns a generated password.
    #
    # @param [String] pattern the pattern
    # @param [Hash] options the options
    # @option options [Boolean] :permute (true) whether or not to randomly permute generated passwords
    # @option options [Boolean] :remove_lookalikes (false) whether or not to remove lookalike characters
    # @option options [Hash] :charset_mapping (CharSet::DEFAULT_MAPPING) the KeePass character set ID mapping
    # @return [String] the new password
    # @raise [InvalidPatternError] if `pattern` is invalid
    def self.generate(pattern, options = {})
      Generator.new(pattern, options).generate
    end

    # Returns whether or not the pattern is valid.
    #
    # @param [String] pattern the pattern
    # @param [Hash] options the options
    # @option options [Boolean] :permute (true) whether or not to randomly permute generated passwords
    # @option options [Boolean] :remove_lookalikes (false) whether or not to remove lookalike characters
    # @option options [Hash] :charset_mapping (CharSet::DEFAULT_MAPPING) the KeePass character set ID mapping
    # @return [Boolean] whether or not the pattern is valid
    def self.validate_pattern(pattern, options = {})
      begin
        generate(pattern, options)
        true
      rescue InvalidPatternError
        false
      end
    end

    # Returns an entropy estimate of a password.
    #
    # @param [String] test the password to test
    # @see http://en.wikipedia.org/wiki/Password_strength
    def self.estimate_entropy(test)
      chars = 0
      chars += 26 if test =~ LOWERCASE_TEST_RE
      chars += 26 if test =~ UPPERCASE_TEST_RE
      chars += 10 if test =~ DIGITS_TEST_RE
      chars += CharSet::PRINTABLE_ASCII_SPECIAL.size if test =~ SPECIAL_TEST_RE
      if chars == 0
        0
      else
        (test.size * Math.log(chars) / Math.log(2)).to_i
      end
    end
  
  end

end
