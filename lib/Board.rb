#!/usr/bin/ruby

# Board class represents the board for the game
class Board
    # Accessor method that returns the board's referee
    attr_reader :ref

    # (Public) Default constructor for a Board object (i.e. `Board.new()`)
    # NOTE: Creates its own new Referee and all its intersections in order to populate its list of intersections, while selected man and intersection initially start off blank
    # NOTE: Instance Varaibles:
    # -> public ref - This variable holds an instance of the Referee class which helps ensure that no rules are violated
    # -> public intersections array - This variable holds an array of Intersection objects, which represents all the intersection points on the board and its corresponding info
    # -> public selected_man intsersection - This variable holds the intersection containing a man piece that is selected by the user
    # -> public selected_intersection intersection - The variable holds the selected intersection that the user wishes to interact with
    def initialize
        @num_white_man = 0
        @num_black_man = 0
        @ref = Referee.new
        @intersections = [] # Populates all the intersections of the board
        COORDINATES.each do |coord|
            @intersections << Intersection.new(coord)
        end
        @selected_man = nil
        @selected_intersection = nil
    end

    # (Public) Returns the board's list of intersections
    # NOTE: Acts as a getter a retrieves the board state directly
    def get_intersections_Array
        @intersections
    end

    # (Public) Returns the number of white or black men remaining on the board (depending on the parameter given)
    def get_num_men(colour)
        colour == :white ? @num_white_man : @num_black_man
    end

    # (Public) Returns the board's selected intersection
    def get_selected_intersection
        @selected_intersection
    end

    # (Public) Returns the board's selected man, which can be used to remove it or use its info to verify required calculations by the referee
    def get_selected_man
        @selected_man
    end

    # (Public) Returns the board state (i.e. a list of intersections rep new board state) to be sent to the opponent player in order to maintain board state for both players
    # NOTE: Retrieves a clone of the board state to not break OO encapsulation
    def get_updated_board
        @intersections.clone
    end

    # (Public) Updates an intersection on the board to match the info of the new intersection given (returns true if successful, otherwise false)
    def set_intersection(intersection)
        updated_intersection_coord = intersection.get_coordinates
        c = 0
        # Search through the board's intersections for the intersection with matching coordinates and update it
        @intersections.each do |i|
            # Updates the matching intersection by removing it and adding the new one, then returns true for success
            if i.get_coordinates == updated_intersection_coord
                @intersections.delete_at(c)
                @intersections << intersection
                return true
            end
            c += 1
        end
        false # should never reach here, return false (no matching intersection coordinates)
    end

    # (Public) Updates the board's list of intersections with the updated placement of a Man (returns true if successful, otherwise false)
    # NOTE: Used during setup phase when the player is taking men from the bag and placing them on the board (at specific intersection coordinates)
    def place(man, coordinates)
        updated_intersection = Intersection.new(coordinates)
        updated_intersection.set_man(man)
        if self.set_intersection(updated_intersection)
            # Increment the number of men on the board appropriately
            man.colour == :white ? @num_white_man += 1 : @num_black_man += 1
            return true
        end
        false # should never reach here, return false (no matching intersection coordinates)
    end

    # (Public) Sends the info of the given current and next intersections to the referee to verify if the piece from the current intersection is able to displace itself to the next intersection legally
    # Note: Upon passing all the checks, it will update the board's list of intersections based on the move (returns true if the move is successful, otherwise false)
    def move(current, next_)
        return false if current.man == nil

        # Referee first validates if the move is legal
        if @ref.is_valid_move(current, next_, self)
            # Clears the board's current intersection of its man, while keeping track of the man, so it can be moved
            man_piece = current.man
            current.set_man(nil)
            return false if !self.set_intersection(current)
            # Places the moved man piece in the next intersection
            return self.place(man_piece, next_.get_coordinates)
        end
        false # move is invalid (ref says it's invalid, or no matching current or next intersection coordinates)
    end

    # (Public) Receives an intersection to be removed from the board and will check with the referee to determine if it is legal
    # Note: Upon passing all the checks, it will update the board's list of intersections by removing the man piece from the specified intersection (returns true if the removal is successful, otherwise false)
    def remove(to_remove)
        # Referee first validates if the removal is legal
        if @ref.is_valid_removal(to_remove, to_remove.man, self)
            # Removes the man from the intersection, while keeping track of the man
            man_colour = to_remove.man.colour
            to_remove.set_man(nil)
            if self.set_intersection(to_remove)
                # Decrement the number of men on the board appropriately
                man_colour == :white ? @num_white_man -= 1 : @num_black_man -= 1
                return true
            end
        end
        false # removal is invalid (ref says it's invalid, or no matching to remove intersection coordinates)
    end

    # (Public) Receives coordinates, selects that intersection from the board, and returns it
    def select_intersection(coordinates)
        # Search through the board's intersections for the intersection with matching coordinates
        @intersections.each do |i|
            # Sets the matching intersection as the board's selected intersection, then also returns it
            if i.get_coordinates == coordinates
                @selected_intersection = i
                return i
            end
        end
        nil # should never reach here, return nil (no matching intersection coordinates)
    end

    # (Public) Checks the board's list of intersections to determine if a man is present at the specified coordinates
    # Note: The board's selected man is updated, then the referee determines
    # if it is the right colour (returns true if the man piece selection is successful
    # because a man exists at the coordinates and matches colour, otherwise false)
    def select_man(coordinates)
        # Search through the board's intersections for the intersection with matching coordinates
        @intersections.each do |i|
            # Sets the matching intersection's man as the board's selected man, then returns true for success
            if i.get_coordinates == coordinates
                @selected_man = i.man
                return i.man != nil 
            end
        end

        false # man selection is invalid (or no matching intersection coordinates)
    end

    # (Public) Updates the other player's board using the given board state of one player (i.e. a list of intersections rep new board state), allowing all players to have the same state of board (returns true if the board update is successful, otherwise false)
    def update_board(new_state)
        # First check if new board state (list of intersections) is valid
        return false if new_state.length != COORDINATES.length

        # Update the board state, then recalculate the number of men remaining on the board
        @intersections = new_state
        @num_white_man = 0
        @num_black_man = 0
        new_state.each do |i|
            # Increment the number of men on the board appropriately
            if i.man
                i.man.colour == :white ? @num_white_man += 1 : @num_black_man += 1
            end
        end
        true # returns true for successful board update
    end
end
