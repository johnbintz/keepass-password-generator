require 'active_support/secure_random'

module KeePass
  
  module Random
    
    # If `n` is a positive integer, then returns a random
    # integer `r` such that 0 <= `r` < `n`.
    #
    # If `n` is 0 or unspecified, then returns a random
    # float `r` such that 0 <= `r` < 1.
    #
    # @param [Integer] n the upper bound
    # @return [Integer|Float] the random number
    # @see ActiveSupport::SecureRandom#random_number
    def self.random_number(n = 0)
      ActiveSupport::SecureRandom.random_number(n)
    end
    
    # Returns a randomly sampled item from the array.
    #
    # @param [Array] array the array to sample from
    # @return [Object] random item or nil if no items exist
    def self.sample_array(array)
      array[random_number(array.size)]
    end
    
    # Returns the array shuffled randomly.
    #
    # @param [Array] array the array to shuffle
    # @return [Array] the shuffled array
    def self.shuffle_array(array)
      array.sort_by { random_number }
    end
    
  end

end
