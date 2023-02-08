class Lifes

  def initialize
    puts "Initializing"
    @visible = true
    @image = Gosu::Image.new("../sprite/life.png")
  end

  def hide
    @visible = false
  end

  def show
    @visible = true
  end

  def draw
    if @visible
      @image.draw(320, 480, 0)
    end
  end

end
