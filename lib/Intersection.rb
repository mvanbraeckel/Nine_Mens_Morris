#!/usr/bin/ruby

#The Intersection Class represents all the available intersections on the board. The Man class
#   will use the Intersection class to show all the men occupying positions on the board.
class Intersection
    attr_reader :man

    def initialize(coordinates)
        raise "Invalid Coordinates Given: #{coordinates}" unless COORDINATES.include?(coordinates)
        @coordinates = coordinates
        @man = nil
    end

    #<public> set_man(man: Man): Boolean - This method takes in a Man object and sets that as
    #   the man on that intersection point by setting it equal to its instance variable man
    def set_man(man)
        @man = man
        if man != nil
            @man.set_location(self.get_coordinates)
        end 
    end

    #<public> get_coordinates(): String - This method will use the instance variable to return the
    #coordinate. (This method acts as a getter for the coordinates)
    def get_coordinates
        @coordinates
    end
end
