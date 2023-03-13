#!/usr/bin/env ruby

require 'bundler/setup'
Bundler.require

require_relative 'Asteroid'
require_relative 'PlayerShip'
require_relative 'Interface'
require_relative 'DataClass'
require_relative 'Stars'
require_relative 'Scrap'

$totalRoids = 0
$score = 0
$maxRoid = 3
$asteroids = []

$canSpawn = false
$roidPart1 = true
$invincible = false
$lifeRemaining = 3
$playerScrap = 0
$playerScrapNeed = 3

Thread.new do
  yaml_data = YAML.load_file('../hScore/hscore.yaml')
  $hScore = yaml_data['hight_score']
end

class GameWindow < Gosu::Window

  def initialize
    super 1920, 1080 , fullscreen: true
    @player = PlayerShip.new(700, 700)
    @start_time = Gosu.milliseconds
    @time_elapsed = 0
    @spawn_speed = 3 # Ajout du compteur à 0.2 secondes
    @spawn_timer = 0 # Initialisation du compteur
    @song = Gosu::Song.new("../ost/airwolf2.mp3")
    @boom = Gosu::Sample.new("../ost/end.mp3")
    @interfaceFont = Gosu::Font.new(24, name: "../font/joystixMonospace.otf")
    @song.play(true)
    @interface = Interface.new()
    $scrapArray = []

    $starray = []
    200.times { $starray << Stars.new(true) }

    Thread.new do
      sleep 1
      loop do
        sleep @spawn_speed
        $canSpawn = true
      end
    end

    Thread.new do
      sleep 5
      loop do
        sleep rand(5..20)
        $canScrapSpawn = true
      end
    end

  end

  def update

    if $canSpawn && $totalRoids < $maxRoid && $roidPart1
      $totalRoids += 1
      $asteroids << Asteroid.new()
      $canSpawn = false
    end

    if $canScrapSpawn
      $canScrapSpawn = false
      $scrapArray << Scrap.new
    end

    @time_elapsed = Gosu.milliseconds - @start_time

    $asteroids.each do |asteroid|
      asteroid.update
      if asteroid.y >= 1080 or @player.collision?(asteroid) == true
        asteroid.reset
        $score += 1
        case
        when $maxRoid < 50
          $maxRoid += 5
        when $maxRoid < 400
          $maxRoid += 2
        when $maxRoid < 600
          $maxRoid += 1
        when $maxRoid > 600
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
    draw_quad(
      1480, 0, 0xff222222,
      1480, 1080, 0xff222222,
      1920, 1080, 0xff222222,
      1920, 0, 0xff222222)

    if $lifeRemaining >= 1
      @player.draw
      @interface.draw($lifeRemaining)
      @interfaceFont.draw_text("Score:#{($score * 0.4).round}", 1500, 50, 0, 1, 1, Gosu::Color::WHITE)
      @interfaceFont.draw_text("B-Score:#{$hScore}", 1500, 100, 0, 1, 1, Gosu::Color::WHITE)
      @interfaceFont.draw_text("Lifes:", 1500, 150, 0, 1, 1, Gosu::Color::WHITE)
    end

    if $lifeRemaining <= 0
      $asteroids.each do |roid|
        $asteroids.delete(roid)
      end
      @song.pause
      @boom.play
      @interface.update_score(($score*0.4).round)
      sleep 10
      exit
    else

      $scrapArray.each do |scrap|
        if @player.largeCollision?(scrap) == true
          if $playerScrap.to_i >= $playerScrapNeed.to_i
            $playerScrapNeed = ($playerScrapNeed*2)
            $playerScrap = 0
            $lifeRemaining +=1
          end
        end
      end

      ($asteroids + $starray + $scrapArray).each do |obj|
        obj.update
        obj.draw
      end

      @player.draw
      @interface.draw($lifeRemaining)
      @interfaceFont.draw_text("Score:#{($score * 0.4).round}", 1500, 50, 0, 1, 1, Gosu::Color::YELLOW)
      @interfaceFont.draw_text("B-Score:#{$hScore}", 1500, 100, 0, 1, 1, Gosu::Color::WHITE)
      @interfaceFont.draw_text("Lifes:", 1500, 150, 0, 1, 1, Gosu::Color::RED)
      @interfaceFont.draw_text("Scraps:#{$playerScrap}/#{$playerScrapNeed}", 1500, 200, 0, 1, 1, Gosu::Color::BLUE)

    end

  end

end

GameWindow.new.show
