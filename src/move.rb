#!/usr/bin/env ruby
require 'gosu'
require 'thread'

require_relative 'Asteroid'
require_relative 'PlayerShip'
require_relative 'Lifes'
require_relative 'DataClass'

SPEED = 5
$totalRoids = 0
$score = 0
$maxRoid = 3
$asteroids = []
$canSpawn = false
$roidPart1 = true
$invincible = false
$lifeRemaining = 3

class GameWindow < Gosu::Window

  def initialize
    super 640, 480  #, fullscreen: true
    @player = PlayerShip.new(320, 240) # INSTANCE et spawn du joueur
    @start_time = Gosu.milliseconds
    @time_elapsed = 0
    @spawn_speed = 3 # Ajout du compteur à 0.2 secondes
    @spawn_timer = 0 # Initialisation du compteur
    @song = Gosu::Song.new("../ost/airwolf2.mp3")
    @clap = Gosu::Sample.new("../ost/choc1.wav")
    @boom = Gosu::Sample.new("../ost/end.mp3")
    @interfaceFont = Gosu::Font.new(19, name: "../font/joystixMonospace.otf")
    @song.play(true)
    @lifeInterface = Lifes.new()
    @lifeInterface.setLifeRemaining($lifeRemaining)
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
      #puts "total roids: #{$totalRoids}    maxRoid: #{$maxRoid}   spawn_speed: #{@spawn_speed}"
      $canSpawn = false
    end

    @time_elapsed = Gosu.milliseconds - @start_time

    $asteroids.each do |asteroid|
      asteroid.update
      if Gosu.distance(@player.x, @player.y+4, asteroid.x, asteroid.y) < 10 && $invincible == false
        puts "test"
        $lifeRemaining -= 1
        @lifeInterface.setLifeRemaining($lifeRemaining)
        $asteroids.delete(asteroid)
        @clap.play
        Thread.new do
          $invincible = true
          sleep 3
          $invincible = false
        end
      end
      if asteroid.y >= 480
        asteroid.reset
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

    end
    @player.update
  end

  def draw
    if $lifeRemaining <= 0
      $asteroids.each do |roid|
        $asteroids.delete(roid)
      end
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
      @lifeInterface.draw
      case
      when $score < 10
        @interfaceFont.draw_text("Score:#{($score * 0.4).round}", 540, 8, 0, 1, 1, Gosu::Color::WHITE)
      when $score < 100
        @interfaceFont.draw_text("Score:#{($score * 0.4).round}", 525, 8, 0, 1, 1, Gosu::Color::WHITE)
      when $score < 1000
        @interfaceFont.draw_text("Score:#{($score * 0.4).round}", 515, 8, 0, 1, 1, Gosu::Color::WHITE)
      when $score < 10000
        @interfaceFont.draw_text("Score:#{($score * 0.4).round}", 500, 8, 0, 1, 1, Gosu::Color::WHITE)
      when $score < 100000
        @interfaceFont.draw_text("Score:#{($score * 0.4).round}", 485, 8, 0, 1, 1, Gosu::Color::WHITE)
      when $score < 1000000
        @interfaceFont.draw_text("Score:#{($score * 0.4).round}", 480, 8, 0, 1, 1, Gosu::Color::WHITE)
      end

    end

    # print a hello world
  end

end

GameWindow.new.show
