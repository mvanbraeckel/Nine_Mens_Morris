#!/usr/bin/ruby

#The Bag class represents the player’s bag and each player will have their own bag which will
#   contain a set of 9 Men (pieces). This allows for an organized way to keep track of the pieces.
class Bag
    attr_accessor :men

    def initialize(colour)
        raise "Invalid Man Colour" unless [:white, :black].include?(colour)
        @men = []
        (0..8).each do
            @men << Man.new(colour)
        end
    end

    #<public> take_from_bag(): Man - Returns a man object from the men array every time a piece
    #   is taken from the bag.
    def take_from_bag
        @men.pop
    end

    #<public> is_empty(): Boolean - Returns true if there are no men left in the men array since
    #   there are no more pieces in the bag, otherwise false is returned.
    def is_empty
        @men.empty?
    end
end
