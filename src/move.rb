#!/usr/bin/env ruby
require 'gosu'
require 'thread'

require_relative 'Asteroid'
require_relative 'PlayerShip'
require_relative 'Lifes'

SPEED = 5
$totalRoids = 0
$score = 0
$maxRoid = 3
$asteroids = []
$canSpawn = false
$roidPart1 = true
$invincible = false

class GameWindow < Gosu::Window
  def initialize
    super 640, 480  #, fullscreen: true
    @player = PlayerShip.new(320, 240) # INSTANCE et spawn du joueur
    @start_time = Gosu.milliseconds
    @time_elapsed = 0
    @spawn_speed = 3 # Ajout du compteur à 0.2 secondes
    @spawn_timer = 0 # Initialisation du compteur
    @collisions = 0
    @song = Gosu::Song.new("../ost/airwolf2.mp3")
    @clap = Gosu::Sample.new("../ost/choc1.wav")
    @boom = Gosu::Sample.new("../ost/end.mp3")
    @song.play(true)
    @life = Lifes.new()
    Thread.new do
      sleep 1
      loop do
        sleep @spawn_speed
        $canSpawn = true
      end
    end
  end

  def update

    if $canSpawn && $totalRoids < $maxRoid && $roidPart1
      $totalRoids += 1
      $asteroids << Asteroid.new()
      puts "total roids: #{$totalRoids}    maxRoid: #{$maxRoid}   spawn_speed: #{@spawn_speed}"
      $canSpawn = false
    end

    @time_elapsed = Gosu.milliseconds - @start_time

    $asteroids.each do |sprite|
      sprite.update
      if sprite.y >= 480
        sprite.reset
        $score += 1

        case
        when $maxRoid < 50
          $maxRoid += 5
        when $maxRoid < 150
          $maxRoid += 2
        when $maxRoid > 200
          $maxRoid -= 1
        end

        if @spawn_speed > 1
          if $maxRoid > $totalRoids + 10
            @spawn_speed -= 0.002
          elsif $maxRoid >= $totalRoids + 3
            @spawn_speed -= 0.001
          end
        end
      end

      if Gosu.distance(@player.x, @player.y+4, sprite.x, sprite.y) < 10 && !$invincible
        @collisions += 1
        $asteroids.delete(sprite)
        @clap.play
        Thread.new do
          puts "invrincible"
          $invincible = true
          sleep 3
          $invincible = false
          puts "not invincible"
        end
      end
    end
    @player.update
  end

  def draw
    if @collisions >= 3
      @song.pause
      @boom.play
      self.caption = "GAME OVER   SCORE : #{$score*0.4}"
      sleep 10
      exit
    else
      $asteroids.each do |roid|
        roid.draw
      end
      @player.draw

    end
  end
end

GameWindow.new.show
