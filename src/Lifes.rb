class Lifes
  attr_reader :lifeRemaining

  def initialize
    @image = Gosu::Image.new("../sprite/life.png")
  end

  def draw
    $x =10
    (@lifeRemaining-1).times do
      @image.draw($x, 10, 20, 2, 2)
      $x += 20
    end
  end

  def setLifeRemaining(value)
    @lifeRemaining = value.to_i
  end
end
