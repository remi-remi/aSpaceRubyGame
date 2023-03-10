class Interface

  def initialize
    @image = Gosu::Image.new("../sprite/life.png")
  end

  def draw(lifeRemaining)
    $x =1600
    (lifeRemaining-1).times do
      @image.draw($x, 142, 20, 4, 4)
      $x += 40
    end
  end


end
