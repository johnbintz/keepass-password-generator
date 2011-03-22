$:.unshift File.expand_path('../../lib', __FILE__)

require 'rspec'
require 'keepass/password/generator'

# module DeterministicRandomness
#   
#   def deterministic_random_number(&block)
#     ActiveSupport::SecureRandom.stub(:random_number) do |arg|
#       if block
#         block.call(arg)
#       else
#         0
#       end
#     end
#   end
#   
#   # def deterministic_shuffle
#   #   Array.any_instance.stub(:shuffle!)
#   # end
# 
# end
# 
# RSpec.configure do |config|
#   config.include DeterministicRandomness
# end

# RSpec::Matchers.define :have_char_set_length_of do |expected|
#   match do |actual|
#     actual.char_sets.size == expected
#   end
# end
