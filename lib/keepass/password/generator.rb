require 'keepass/password/char_set'
require 'keepass/random'

module KeePass
  
  module Password

    class InvalidPatternError < RuntimeError; end
  
    # Generate passwords using KeePass password generator patterns.
    #
    # @see http://keepass.info/help/base/pwgenerator.html
    class Generator

      # Available character sets
      CHARSET_IDS       = CharSet::DEFAULT_MAPPING.keys.join

      # ASCII printables regular expression
      LITERALS_RE       = /[\x20-\x7e]/
      CHAR_TOKEN_RE     = Regexp.new("([#{CHARSET_IDS}])|\\\\(#{LITERALS_RE.source})")
      GROUP_TOKEN_RE    = Regexp.new("(#{CHAR_TOKEN_RE.source}|" + 
                                     "\\[((#{CHAR_TOKEN_RE.source})*?)\\])" +
                                     "(\\{(\\d+)\\})?")
      VALIDATOR_RE      = Regexp.new("\\A(#{GROUP_TOKEN_RE.source})+\\Z")

      LOOKALIKE         = "O0l1I|"
      LOOKALIKE_CHARSET = CharSet.new.add_from_strings LOOKALIKE

      # @return [String] the pattern
      attr_reader :pattern
    
      # @return [Array<CharSet>] the character sets from the pattern
      attr_reader :char_sets

      # @return [Boolean] whether or not to permute the password
      attr_accessor :permute

      # Instantiates a new PasswordGenerator object.
      #
      # @param [String] pattern the pattern
      # @param [Hash] options the options
      # @option options [Boolean] :permute (true) whether or not to randomly permute generated passwords
      # @option options [Boolean] :remove_lookalikes (false) whether or not to remove lookalike characters
      # @option options [Hash] :charset_mapping (CharSet::DEFAULT_MAPPING) the KeePass character set ID mapping
      # @return [PasswordGenerator] self
      # @raise [InvalidPatternError] if `pattern` is invalid
      def initialize(pattern, options = {})
        @permute = options.has_key?(:permute) ? options[:permute] : true
        @pattern = pattern
        @char_sets = pattern_to_char_sets(pattern, options)
      end

      # Returns a new password.
      #
      # @return [String] a new password
      def generate
        result = char_sets.map { |c| Random.sample_array(c.to_a) }
        result = Random.shuffle_array(result) if permute
        result.join
      end
      
      private
      
        def pattern_to_char_sets(pattern, options) #:nodoc:
          remove_lookalikes = options[:remove_lookalikes] || false
          mapping = options[:charset_mapping] || CharSet::DEFAULT_MAPPING
          char_sets = []
          i = 1
          pattern.scan(GROUP_TOKEN_RE) do |x1, char, bs_char, char_group, x5, x6, x7, x8, repeat|
            char_set = CharSet.new
            char_set.mapping = mapping
            begin
              if char
                char_set.add_from_char_set_id(char)
              elsif bs_char
                char_set.add(bs_char)
              else
                char_group.scan(CHAR_TOKEN_RE) do |c, e|
                  if c
                    char_set.add_from_char_set_id(c)
                  else
                    char_set.add(e)
                  end
                end
              end
            rescue InvalidCharSetIDError => e
              raise InvalidPatternError, e.message
            end
            char_set -= LOOKALIKE_CHARSET if remove_lookalikes
            if char_set.empty?
              raise InvalidPatternError, "empty character set for token #{i} for #{pattern.inspect}"
            end
            (repeat ? repeat.to_i : 1).times { char_sets << char_set }
            i += 1
          end

          if char_sets.any?
            char_sets
          else
            raise InvalidPatternError, "no char sets from #{pattern.inspect}"
          end

        end
        
      # private
      
    end

  end

end
