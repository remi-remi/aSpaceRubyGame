require 'gosu'

class GameWindow < Gosu::Window
  WIDTH = 1920
  HEIGHT = 1080
  $orientation = true

  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "Bullets!"

    @bullets = []
    @last_bullet_time = 0
  end

  def update
    # Create a new bullet every x000 seconds
    if (Gosu.milliseconds - @last_bullet_time) > 300
      @last_bullet_time = Gosu.milliseconds

        pos = rand(-5..30)
        for j in pos..pos+5
          @bullets << Bullet.new(j * 50 + 1 * 200, -30 - 1 * 50, @bullet_image,true)
        end
        pos = rand(-5..30)
        for j in pos..pos+5
          @bullets << Bullet.new(j * 50 + 1 * 200, -30 - 1 * 50, @bullet_image,false)
        end
      #end
    end

    # Update bullet positions
    @bullets.each do |bullet|
      bullet.update
    end

    # Remove bullets that are off the screen
    @bullets.reject! do |bullet|
      bullet.y > HEIGHT
    end
  end

  def draw
    # Draw bullets
    @bullets.each do |bullet|
      bullet.draw
    end
  end
end



class Bullet
  $BULLET_SPEED = 2
  $BULLET_DIAG = 1
  attr_reader :x, :y

  def initialize(x, y, image_name, right)
    @x = x
    @y = y
    @image = Gosu::Image.new('../sprite/blueShard1.png')
    @right = right
    @angle = @right ? 140 : 50
    @center_x = @image.width / 2
    @center_y = @image.height / 2
    @scale_x = 1
    @scale_y = 1
  end

  def update
    @y += $BULLET_SPEED
    if @right
      @x += $BULLET_DIAG
    else
      @x -= $BULLET_DIAG
    end
  end

  def draw
    @image.draw_rot(@x, @y, 0, @angle, 1, 1, @center_x, @center_y, @scale_x, @scale_y)
  end
end


# Create and run the game window
window = GameWindow.new
window.show
