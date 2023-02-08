class PlayerShip
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
    @image = Gosu::Image.new("../sprite/ship.png")
  end

  def update
    speed = SPEED
    if Gosu.button_down?(Gosu::KbLeftShift)
      speed /= 2
    end
    if Gosu.button_down?(Gosu::KbLeft)
    @x -= speed
    end
    if Gosu.button_down?(Gosu::KbRight)
      @x += speed
    end
    if Gosu.button_down?(Gosu::KbUp)
      @y -= speed
    end
    if Gosu.button_down?(Gosu::KbDown)
      @y += speed
    end
  end

  def draw
    @image.draw(@x, @y, 0)
  end

end
