class Scrap
  attr_reader :x, :y, :speed

  Thread.new do
    while $scrapArray.size < 200
     $scrapArray << Scrap.new()
     sleep 0.5
    end
 end

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
