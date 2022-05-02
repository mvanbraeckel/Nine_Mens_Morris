#!/usr/bin/ruby

#The player class represents the actors also known as the players of the game. The player will
#   have a title and their coloured pieces. The player will be responsible for grabbing pieces from
#   the bag and is also in charge of moving and removing their men on the board.
class Player
    attr_accessor :colour
    attr_reader :bag

    def initialize(name, colour)
        raise "Invalid Colour" unless [:white, :black].include?(colour)
        @colour = colour
        @name = name
        @bag = self.generate_bag
    end

    #<public> get_name(): String - The method will return the name of the players, player 1 and player 2
    def get_name
        @name
    end

    # <public> generate_bag(): bag - The method associates a bag with a player. At the beginning
    #       of the game, two bags are generated for player 1 and player 2 which will contain 9 coloured
    #       men. Player 1 will have 9 white men in the bag and player 2 will have 9 black men in the bag.
    def generate_bag
        Bag.new(@colour)
    end
end
