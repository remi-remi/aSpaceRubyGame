class Stars
  attr_reader :x, :y, :speed, :fuzzy


  Thread.new do
    sleep 0.3
    13.times do
     $starray << Stars.new(true)
    end
    while $starray.size < 200
     $starray << Stars.new(false)
     sleep 0.3
    end
 end

  def initialize(fuzzy)
    puts "init"
    @fuzzy = fuzzy
    @speed = rand(0.8..1)
    @x = rand(0..1480)

    @image = Gosu::Image.new("../sprite/star.png")
    @size = rand(0.7..2)
    if @fuzzy
      @y = rand(0..1080)
    else
      @y = -30
    end
  end

  def update
    @y += @speed
    if @y >= 1080
      @y = -30
      @x = rand(0..1480)
      @size = rand(0.7..2)
    end
  end

  def draw
    @image.draw(@x, @y, -10, @size, @size)
  end

end
