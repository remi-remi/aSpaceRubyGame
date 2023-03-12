class Scrap
  attr_reader :x, :y, :speed

  def initialize()
    @image = Gosu::Image.new("../sprite/scrap/scrap1.png")
    @speed = rand(0.2..0.8)
    @x = rand(0..1480)
    @y = -30
    @size = 1
  end

  def update
    @y += @speed
    if @y >= 1080
      @y = -30
      @x = rand(0..1480)
    end
  end

  def draw
    @image.draw(@x, @y, -10, 1, 1)
  end

end
