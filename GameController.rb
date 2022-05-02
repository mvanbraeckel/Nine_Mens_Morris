#!/usr/bin/ruby
require './Nine_Men_Morris_Classes'
class GameController

    def initialize
        @current_game = nil
        @board = nil
        @player_black = nil
        @player_white = nil
    end

    def create
        # Display welcome message and prompt user(s) for player names
        puts "Welcome to Nine Men's Morris!"
        valid_name = false
        while !valid_name
            print "Enter Player 1's name: "
            playerOneName = gets.chomp
            puts "-Error: Invalid name '#{playerOneName}' - must be at least one character, please try again." unless valid_name = playerOneName.length > 0
        end
        valid_name = false
        while !valid_name
            print "Enter Player 2's name: "
            playerTwoName = gets.chomp
            puts "-Error: Invalid name '#{playerTwoName}' - must be at least one character, please try again." unless valid_name = playerTwoName.length > 0
        end

        # Use provided info to create the start of the game
        @current_game = Game.new(playerOneName, playerTwoName)
        @board = @current_game.board
        @player_black = @current_game.black
        @player_white = @current_game.white
    end

    def play
        playerName = @current_game.current_turn == :white ? @player_white.get_name : playerName = @player_black.get_name
        puts("#{playerName}'s (#{@current_game.current_turn}) turn")
        self.display

        # Play turn
        if @current_game.phase == 1
            result = false
            while !result
                print "Enter a coordinate to place your piece: "
                coordinate = gets.chomp.upcase
                # Check if valid coordinate
                if !COORDINATES.include?(coordinate)
                    puts "-Error: Invalid coordinate, please try again."
                    next
                end

                result = self.place(coordinate)
            end
        else @current_game.phase == 2
            result = false
            while !result
                print "Enter the coordinate of your piece to move: "
                piece_coordinate = gets.chomp.upcase
                # Check if valid coordinate
                if !COORDINATES.include?(piece_coordinate)
                    puts "-Error: Invalid coordinate, please try again."
                    next
                end

                print "Enter the coordinate to move the piece to: "
                destination_coordinate = gets.chomp.upcase
                # Check if valid coordinate
                if !COORDINATES.include?(destination_coordinate)
                    puts "-Error: Invalid coordinate, please try again."
                    next
                end

                result = self.move(piece_coordinate, destination_coordinate)
            end

            # Only check winner in phase 2
            @board.update_board(@board.get_updated_board)
            winner = @current_game.end()
            if winner != nil
                self.display
                puts "#{winner} wins!"
                return
            end
        end

        # Pass turn
        self.end_turn
    end

    def place(place_coordinates)
        if (place_coordinates == nil ||
            @board.select_intersection(place_coordinates) == nil ||
            @board.select_intersection(place_coordinates).man != nil)

            puts "-Error: Invalid piece placement, please try again."
            return false
        end

        man = @current_game.current_turn == :white ? @player_white.bag.take_from_bag : @player_black.bag.take_from_bag

        @board.place(man, place_coordinates)

        @current_game.update_phase if @player_white.bag.is_empty && @player_black.bag.is_empty


        # Prompt to remove if there are pieces to remove
        self.remove if @board.ref.verify_mill(@board, @board.select_intersection(place_coordinates))
        if @current_game.phase == 2
            @board.update_board(@board.get_updated_board)
            winner = @current_game.end()
            if winner != nil
                self.display
                puts "#{winner} wins!"
                exit()
            end
        end
        true
    end

    def move(from, to)

        @board.ref.can_fly(@board.get_num_men(@current_game.current_turn))

        from_intersection = @board.select_intersection(from)
        to_intersection = @board.select_intersection(to)

        result = @board.move(from_intersection, to_intersection)

        if !result
            puts "-Error: Invalid move, please choose intersections again." 
            return false
        end 

        self.remove if @board.ref.verify_mill(@board, @board.select_intersection(to))

        true
    end

    def remove
        self.display

        result = false
        while !result
            print "Enter the coordinate of an opponent piece to remove: "
            to_remove_coordinate = gets.chomp.upcase
            # Check if valid coordinate
            if !COORDINATES.include?(to_remove_coordinate)
                puts "-Error: Invalid coordinate, please try again."
                next
            end
            to_remove_intersection = @board.select_intersection(to_remove_coordinate)
            result = @board.remove(to_remove_intersection)

            if !result
                puts "-Error: Invalid piece selected for removal, please try again."
                next
            end
        end

        true
    end

    def end_turn
        @current_game.switch_player_turn
        @board.ref.update_current_player_color(@current_game.current_turn)
        self.play
    end

    def display
        # Declare initial symbols for the display board
        black_piece_symbol = "○"
        white_piece_symbol = "●"
        board_intersections = {
            "A1" => "└",
            "A4" => "├",
            "A7" => "┌",
            "B2" => "└",
            "B4" => "┼",
            "B6" => "┌",
            "C3" => "└",
            "C4" => "┤",
            "C5" => "┌",
            "D1" => "┴",
            "D2" => "┼",
            "D3" => "┬",
            "D5" => "┴",
            "D6" => "┼",
            "D7" => "┬",
            "E3" => "┘",
            "E4" => "├",
            "E5" => "┐",
            "F2" => "┘",
            "F4" => "┼",
            "F6" => "┐",
            "G1" => "┘",
            "G4" => "┤",
            "G7" => "┐",
        }

        # Set each intersection on the display board with the appropriate symbol connector or man piece symbol
        @board.get_intersections_Array.each { |intersection|
            # Only if intersection contains a man
            if intersection.man != nil
                # Check the colour of the man
                colour_piece_symbol = intersection.man.colour == :black ? black_piece_symbol : white_piece_symbol
                # Set the man piece symbol on the display board's intersection
                board_intersections[intersection.get_coordinates.upcase] = colour_piece_symbol
            end
        }

        # Display the game state via an ASCII style full board for the current player's turn
        
        puts """
            7  #{board_intersections["A7"]}───────#{board_intersections["D7"]}───────#{board_intersections["G7"]}
            6  │ #{board_intersections["B6"]}─────#{board_intersections["D6"]}─────#{board_intersections["F6"]} │
            5  │ │ #{board_intersections["C5"]}───#{board_intersections["D5"]}───#{board_intersections["E5"]} │ │
               │ │ │       │ │ │
            4  #{board_intersections["A4"]}─#{board_intersections["B4"]}─#{board_intersections["C4"]}       #{board_intersections["E4"]}─#{board_intersections["F4"]}─#{board_intersections["G4"]}
               │ │ │       │ │ │
            3  │ │ #{board_intersections["C3"]}───#{board_intersections["D3"]}───#{board_intersections["E3"]} │ │
            2  │ #{board_intersections["B2"]}─────#{board_intersections["D2"]}─────#{board_intersections["F2"]} │
            1  #{board_intersections["A1"]}───────#{board_intersections["D1"]}───────#{board_intersections["G1"]}
               A B C   D   E F G"""
    end
end

