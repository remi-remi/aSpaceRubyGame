require 'gosu'
class GameWindow < Gosu::Window
  WIDTH = 1920
  HEIGHT = 1080
  $BULLET_SPEED = 0.3
  $BULLET_LEFT = 4
  BULLET_POOL_SIZE = 900
  $posX=50
  $posY=10

  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "Bullets!"
    @bullets = Array.new(BULLET_POOL_SIZE) { Bullet.new(0, 0, 0, 0) }
    @next_bullet_index = 0
    @last_bullet_time = 0
    @current_salvo_id = 0 # Ajout de cette ligne
  end

  def update
    # Create a new bullet every 10 seconds
    if (Gosu.milliseconds - @last_bullet_time) > 300
      @last_bullet_time = Gosu.milliseconds
      # Create 5 bullet salvos with a gap of 50 pixels between each bullet
      $posX += 150
      $posX =$posX.modulo(1900)
      $posY += 20
      $posY =$posY.modulo(1050)

      @current_salvo_id += 1

      for j in 0..25
        # Get the next available bullet from the pool
        bullet = @bullets[@next_bullet_index]
        @next_bullet_index = (@next_bullet_index + 1) % BULLET_POOL_SIZE
        # Initialize the bullet's position and angle
        bullet.initialize_at($posX, $posY, j * 14.4, @current_salvo_id)
      end
    end

    # Update bullet positions
    @bullets.each do |bullet|
      bullet.update
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
  attr_reader :x, :y, :angle
  @@image = Gosu::Image.new('../sprite/blueShard1.png')

  def initialize(x, y, angle, salvo_id)
    @x = x
    @y = y
    @angle = angle
    @speed = 1
    @counter = 0
    @waiting = 0
    @rotated = false
    @salvo_id = salvo_id
  end

def initialize_at(x, y, angle, salvo_id)
  @x = x
  @y = y
  @angle = angle
  @counter = 0
  @waiting = 0
  @rotated = false
  @salvo_id = salvo_id
end

def update
  @counter += 1
  x_offset = Gosu::offset_x(@angle, @speed)
  y_offset = Gosu::offset_y(@angle, @speed)

  if @counter == 60 && !@rotated && @salvo_id != 0
    @waiting = 60
  end

  if @waiting > 0
    @waiting -= 1
  elsif @waiting == 0 && !@rotated && @salvo_id != 0
    @angle += 90
    @speed = 0
    @counter = 0
    @waiting = 60
    @rotated = true
  elsif @waiting == 0 && @rotated && @salvo_id != 0
    @speed = 3
    @x += x_offset
    @y += y_offset
    @salvo_id = 0
  else
    @x += x_offset
    @y += y_offset
  end

  # If the bullet is off screen, mark it as inactive and reset its state
  if @y > GameWindow::HEIGHT
    @x = 0
    @y = 0
    @angle = 0
    @rotated = false
    @counter = 0
    @waiting = 0
    @salvo_id = 0
  end
end






  def draw
    # Dessiner le projectile en rotation à sa position actuelle
    @@image.draw_rot(@x, @y, 1, @angle, 0.5, 0.5, 1, 1)
  end
end


# Create and run the game window
window = GameWindow.new
window.show
