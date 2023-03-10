class PlayerShip
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
    @image = Gosu::Image.new("../sprite/ship.png")
    @shield = Gosu::Image.new("../sprite/ivFrame.png")
    @roidColideSound = Gosu::Sample.new("../ost/choc1.wav")
  end

  def update
    speed = SPEED
    if Gosu.button_down?(Gosu::KbLeftShift)
      speed /= 2
    end
    if Gosu.button_down?(Gosu::KbLeft) && @x > 0
      @x -= speed
    end
    if Gosu.button_down?(Gosu::KbRight) && @x < 1920 - @image.width
      @x += speed
    end
    if Gosu.button_down?(Gosu::KbUp) && @y > 0
      @y -= speed
    end
    if Gosu.button_down?(Gosu::KbDown) && @y < 1080 - @image.height
      @y += speed
    end
  end

  def draw
    @image.draw(@x, @y, 0)
    if $invincible
      @shield.draw(@x-10, @y-10, 1, 2, 2)
    end
  end

  def collision?(bullet) # returns true if collision
    if Gosu.distance(@x, @y+4, bullet.x, bullet.y) < 10 && $invincible == false
      puts "test"
      $lifeRemaining -= 1
      bullet.reset
      @roidColideSound.play
      Thread.new do
        $invincible = true
        sleep 3
        $invincible = false
      end
    end
  end

end
