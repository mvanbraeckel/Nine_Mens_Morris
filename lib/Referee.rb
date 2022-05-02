#!/usr/bin/ruby
class Referee
    # <private> black_mill_count - Holds count of mill for player playing black
    # <private> white_mill_count - Holds count of mill for player playing white
    # <public> white_can_fly: Boolean - This boolean variable holds the value true or false for if
    # white pieces can fly on the board. If this variable holds true then white players can move their
    # piece on any available space on the board (e.g. fly). If this variable holds false then the white
    # players can’t fly and must make a move that is in an open adjacent point on the board.
    # <public> black_can_fly: Boolean - This boolean variable holds the value true or false for if
    # black pieces can fly on the board. If this variable holds true then black players can move their
    # piece on any available space on the board (e.g. fly). If this variable holds false then the black
    # players can’t fly and must make a move that is in an open adjacent point on the board.
    # <public> mills: Array <Array<coordinates>> - This variable has an array of each of the current mills and there coordinates
    # <public> current_player_color: enum {‘white’, ‘black’} - this holds current player color
    def initialize
        @black_mill_count = 0
        @white_mill_count = 0
        @white_can_fly = false
        @black_can_fly = false
        @mills = []
        @current_player_color = nil
    end

    # <public> verify_mill(board: Board, current: Intersection):Boolean -
    # This method will take in the current state of the board and the intersection to which the player is
    # moved. This method will check preset combinations of valid mill locations from the mill's
    # instance variable with the current state of board and the intersection to which the player has
    # moved to. If a mill is created then mill count is updated by adding 1 and men in the combination
    # are set to non removable. If a mill is broken then mill count is updated by removing 1 and men in
    # from the broken mill are set to removable. Finally, this method returns true if a mill was created
    # and false if no mill was created.
    def verify_mill(board, current)
        # Assuming that the design has moved the piece to current
        coordinate = current.get_coordinates
        # Due to there being no fixed interconections have to do this with fixed values
        # Would rather not due this but only way to get it to work with the design
        mills = [
            # Adding all possible vertical mills
            ["A7","A4","A1"],
            ["B6","B4","B2"],
            ["C5","C4","C3"],
            ["D7","D6","D5"],
            ["D3","D2","D1"],
            ["E5","E4","E3"],
            ["F6","F4","F2"],
            ["G7","G4","G1"],
            # Adding all possible horizontal mills
            ["A7","D7","G7"],
            ["B6","D6","F6"],
            ["C5","D5","E5"],
            ["A4","B4","C4"],
            ["E4","F4","G4"],
            ["C3","D3","E3"],
            ["B2","D2","F2"],
            ["A1","D1","G1"]
        ]

        # Resetting mill values since we are recalculating all the associated mills
        @black_mill_count = 0
        @white_mill_count = 0
        @mills = []

        mill_created = false
        mills.each do |mill|
            mill_found = true
            associate_value = false
            color = nil

            mill.each do |coord|
                
                coord_intersection = board.select_intersection(coord)
                coord_man = coord_intersection.man
                if color == nil && coord_man != nil
                    color = coord_man.colour
                end

                if coord == coordinate
                    associate_value = true
                end

                if !coord_man || color != coord_man.colour
                    mill_found = false
                    break
                end
            end
            if associate_value
                mill_created = mill_found || mill_created
            end

            if mill_found
                color == :white ? @white_mill_count += 1 : @black_mill_count += 1
                @mills << mill
                mill.each do |coord|
                    if board.select_man(coord)
                        board.get_selected_man.set_removable(false)
                    end
                end
            else
                mill.each do |coord|
                    if board.select_man(coord)
                        board.get_selected_man.set_removable(false)
                    end
                end
            end
        end
        mill_created
    end

    def update_current_player_color(color)
        raise "Invalid Man Colour" unless [:white, :black].include?(color)
        @current_player_color = color
    end

    # <public> is_valid_selected_man(selected_man: Man) : Boolean - this method takes in the
    # current selected man and checks to see if the color of the Man matches the color assigned to
    # the current player. If colors do not match this returns false, else this returns true.
    def is_valid_selected_man(selected_man)
        @current_player_color != selected_man.colour
    end 

    # <public> can_fly(numOfMen: integer) : Boolean - This method will verify if a player can fly.
    # This method will use the numOfMen to determine if the current player can fly. If the number of
    # Men is equal to 3 then a true value will be returned, verifying that a player can fly.
    def can_fly(numOfMen)
        if numOfMen <= 3
            @current_player_color == :white ? @white_can_fly = true : @black_can_fly = true
            true
        else
            @current_player_color == :white ? @white_can_fly = false : @black_can_fly = false
            false
        end
    end

    # <public> is_valid_move(from: Intersection, to: Intersection, board : Board) : Boolean -
    # This method verifies if a potential move is valid or not. A valid move means that none of the
    # rules for moving men is violated. An example of such a rule would be: a man can’t move to a
    # point that is already occupied. Here the method takes in a from intersection, to intersection and
    # a board. With these parameters the method uses the current location (from) and the new
    # location (to) and verifies with the board to make sure the move being made is legal. The
    # is_valid_move method returns a boolean; if it returns true then that means that the potential
    # move is valid and the player is free to move their piece there. Alternatively, if it returns false that
    # means that the potential move is not valid and the player can’t move to that location.
    def is_valid_move(from, to, board)
        return false if !from.man

        if is_valid_selected_man(from.man)
            puts "-Error: Wrong man colour"
            return false
        end

        valid_moves = determine_available_moves(from, board)
        valid_moves.each do |intersection|
            return true if intersection.get_coordinates.eql?(to.get_coordinates)
        end

        false
    end

    # <public> is_valid_removal(selected_Intersection: Intersection, to_remove: Man, board:
    # Board ) - This method checks if the removal of an opponent player’s man is valid or not. The
    # reason for this method is that Nine Men’s Morris has a few rules around removing an opponent
    # player's piece. One of those rules is that if there are other opponent men available for removal
    # then an opponent’s man in a mill cannot be removed. This method checks that such rules are
    # not violated. This method takes in the selected intersection, the man to remove and the board to
    # validate the removal. The method returns a boolean value; if it returns true that means the
    # removal is valid. Alternatively, if it returns false, then that means that the removal is invalid.
    def is_valid_removal(selected_Intersection, to_remove, board)
        return false if to_remove == nil || to_remove.colour == @current_player_color

        # Check if to_remove is part of an existing mill
        coordinate = selected_Intersection.get_coordinates
        in_mill = false
        @mills.each do |mill|
            mill.each do |coord|
                if coord == coordinate
                    in_mill = true
                    break
                end
            end
        end

        if !in_mill
            return true
        end

        active_pieces = []
        COORDINATES.each do |coord|
            board.select_man(coord)
            m = board.get_selected_man
            if m != nil && m.colour != @current_player_color
                active_pieces << coord
            end
        end

        only_mill_pieces = true
        active_pieces.each do |piece|
            piece_in_mills = false
            @mills.each do |mill|
                mill.each do |coord|
                    if coord == piece
                        piece_in_mills = true
                        break
                    end
                end
            end
            if !piece_in_mills
                only_mill_pieces = false
            end
        end
        only_mill_pieces
    end

    # <public> winner_check(board: Board) : enum(‘white’, ‘black’) - this methods checks the number of the number of men for each color and if it is less 3 the game is over. 
    # This also checks the number of available move for every piece remaining. If there is no available moves then the game ends and winner is declared.
    def winner_check(board)
        return :black if board.get_num_men(:white) < 3
        return :white if board.get_num_men(:black) < 3

        black_can_move = false
        white_can_move = false
        COORDINATES.each do |coord|
            board.select_intersection(coord)
            intersection = board.get_selected_intersection

            next if !intersection.man # skip intersections without men
            #double check this actually works

            is_black = intersection.man.colour != :white

            if is_black && !black_can_move
                if determine_available_moves(intersection, board).length > 0
                    black_can_move = true
                end
            elsif !is_black && !white_can_move
                if determine_available_moves(intersection, board).length > 0
                    white_can_move = true
                end
            end
        end

        return :white if white_can_move && !black_can_move
        return :black if black_can_move && !white_can_move
        nil
    end

    # <public> determine_available_moves(intersection : Intersection, board : Board) :
    # Array<Intersection> - This method is supposed to find out all the available moves currently on
    # the board. It takes in an intersection and a board object. The intersection holds the current
    # location of the man the player wants to move. The board object holds the current state of the
    # board. The method returns an array of all the intersections which are available for the man to
    # move to.
    def determine_available_moves(intersection, board)
        return [] if intersection.man == nil
        intersections = []
        can_fly = @current_player_color == :white ? @white_can_fly : @black_can_fly

        if can_fly
            COORDINATES.each do |coord|
                if !board.select_man(coord)
                    intersections << board.select_intersection(coord)
                end
            end
        else
            # Again, only way to check if an item is connected AKA hardcoded values
            # Wish I didn't have to do this but don't how else it could be done with the current design
            connected = CONNECTED_INTERSECTIONS[intersection.get_coordinates]
            connected.each do |coord|
                if !board.select_man(coord)
                    intersections << board.select_intersection(coord)
                end
            end
        end
        intersections
    end
end
