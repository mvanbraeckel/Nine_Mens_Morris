#!/usr/bin/ruby
require "./Nine_Men_Morris_Classes"
require "./GameController.rb"

puts("Man drivers")
man = Man.new(:white)
puts(man.is_removable)
man.set_removable(false)
puts(man.is_removable)
man.set_location("A1")
puts(man.current_location)

puts("Game drivers")
g = Game.new("Bob","Jeb")
g.order_player

game = GameController.new
game.create
game.play
