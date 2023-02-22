class Asteroid
  attr_reader :x, :y, :speed, :angle

  def initialize()
    @x = rand(0..640)
    @y = -30
    case rand(1..4)
    when 1
      @image = Gosu::Image.new("../sprite/roid1.png")
    when 2
      @image = Gosu::Image.new("../sprite/roid2.png")
    when 3
      @image = Gosu::Image.new("../sprite/roid3.png")
    when 4
      @image = Gosu::Image.new("../sprite/roid4.png")
    end
    @speed = rand (1.8..2.5)
    @angle = rand(0..360)
  end

  def update
    @y += @speed
  end

  def draw
    @image.draw_rot(@x, @y, 0, @angle)
  end

  def reset
    @x = rand(0..640)
    @y = -30
    @angle = rand(0..360)
  end


end
