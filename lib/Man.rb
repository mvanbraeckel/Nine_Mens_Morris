#!/usr/bin/ruby

#The Man class represents the pieces used by the game. The only available information in this
#   class will be about a single piece and the properties it holds. The Player and Board will utilize
#   the Man class in order to verify positions and play the game.
class Man
    attr_reader :colour

    def initialize(colour)
        raise "Invalid Man Colour" unless [:white, :black].include?(colour)
        @colour = colour
        @xy_coordinates = nil
        @removable = true
    end

    #<public> set_location(coordinates:String): void - This method will receive the coordinates as
    #   a string and will update the Man’s location. This method will return void
    def set_location(coordinates)
        @xy_coordinates = coordinates
        # TODO: Code to be implemented when we bring everything together: Board.
        nil
    end

    #<public> current_location(): String - This method will return the xy_coordinate value as a
    #string along with the colour of the piece.
    def current_location
        @xy_coordinates
    end

    #<public> set_removable(is_removable: Boolean): void - This method will set the removable
    #   instance variable based on the value provided
    def set_removable(is_removable)
        @removable = is_removable
        nil
    end

    #<public> is_removable(): Boolean - This method will return the removable instance variable to
    #   show whether the current piece (man) is removable or not
    def is_removable
        @removable
    end
end
