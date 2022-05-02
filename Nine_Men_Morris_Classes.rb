#!/usr/bin/ruby

COORDINATES = [
    "A1",
    "A4",
    "A7",
    "B2",
    "B4",
    "B6",
    "C3",
    "C4",
    "C5",
    "D1",
    "D2",
    "D3",
    "D5",
    "D6",
    "D7",
    "E3",
    "E4",
    "E5",
    "F2",
    "F4",
    "F6",
    "G1",
    "G4",
    "G7"
]

CONNECTED_INTERSECTIONS = {
    "A1" => ["A4", "D1"],
    "D1" => ["A1", "G1", "D2"],
    "G1" => ["D1", "G4"],
    "B2" => ["B4", "D2"],
    "D2" => ["B2", "F2", "D1", "D3"],
    "F2" => ["D2", "F4"],
    "C3" => ["D3", "C4"],
    "D3" => ["C3", "E3", "D2"],
    "E3" => ["D3", "E4"],
    "A4" => ["B4", "A1", "A7"],
    "B4" => ["A4", "C4", "B2", "B6"],
    "C4" => ["B4", "C3", "C5"],
    "E4" => ["F4", "E3", "E5"],
    "F4" => ["E4", "G4", "F2", "F6"],
    "G4" => ["F4", "G1", "G7"],
    "C5" => ["D5", "C4"],
    "D5" => ["C5", "E5", "D6"],
    "E5" => ["D5", "E4"],
    "B6" => ["D6", "B4"],
    "D6" => ["B6", "F6", "D5", "D7"],
    "F6" => ["D6", "F4"],
    "A7" => ["D7", "A4"],
    "D7" => ["A7", "G7", "D6"],
    "G7" => ["D7", "G4"]
}

require "./lib/Referee.rb"
require "./lib/Bag.rb"
require "./lib/Player.rb"
require "./lib/Board.rb"
require "./lib/Game.rb"
require "./lib/Intersection.rb"
require "./lib/Man.rb"
