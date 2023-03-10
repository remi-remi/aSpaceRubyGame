class Lifes

  def initialize
    @image = Gosu::Image.new("../sprite/life.png")
  end

  def draw(lifeRemaining)
    $x =10
    (lifeRemaining-1).times do
      @image.draw($x, 10, 20, 2, 2)
      $x += 20
    end
  end

end
