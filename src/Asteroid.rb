class Asteroid
  attr_reader :x, :y, :speed, :angle

  def initialize()
    @x = rand(0..640)
    @y = -30
    @image = Gosu::Image.new("../sprite/roid1.png")
    @speed = 2
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
