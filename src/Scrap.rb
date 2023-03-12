class Scrap
  attr_reader :x, :y, :speed

  def initialize()
    @image = Gosu::Image.new("../sprite/scrap/scrap#{rand(1..3)}.png")
    @speed = rand(0.2..0.8)
    @x = rand(0..1480)
    @y = -30
    @size = 2
  end

  def update
    @y += @speed
    if @y >= 1080
      $scrapArray.delete(self)
    end
  end

  def draw
    @image.draw(@x, @y, 5, @size, @size)
  end

  def colide
    $scrapArray.delete(self)
    $playerScrap += 1
  end

end
