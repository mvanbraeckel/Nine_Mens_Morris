#!/usr/bin/ruby

class Game
    attr_accessor :current_turn, :phase
    attr_reader :board, :white, :black

    def initialize(playerOneName, playerTwoName)
        @board = Board.new
        @white = Player.new(playerOneName, :white)
        @black = Player.new(playerTwoName, :black)
        @current_turn = :white
        @phase = 1
    end

    def update_phase
        @phase += 1
    end

    # randomizes colour of players
    # rename this function??? --> randomize_player_colours
    def order_player
        if [:white, :black].sample == :white
            @white.colour = :white
            @black.colour = :black
        else
            @white.colour = :black
            @black.colour = :white
        end
    end

    def switch_player_turn
        @current_turn = @current_turn == :white ? :black : :white
    end

    def end
        @winner = @board.ref.winner_check(@board)
    end
end
