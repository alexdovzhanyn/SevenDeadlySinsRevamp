class Humanoid
  attr_reader :bounding_box

  def initialize(x, y, z, w, h, move_speed = 5)
    @bounding_box = BoundingBox.new(x, y, z, w, h)
    @move_speed = move_speed
  end

  def draw
    if (needs_render?)
      Gosu.draw_rect(bounding_box.x, bounding_box.y, bounding_box.w, bounding_box.h, Gosu::Color::RED, bounding_box.z)
    end
  end

  def update
    if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
      move :left
    end
    if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
      move :right
    end
    if Gosu.button_down? Gosu::KB_UP or Gosu::button_down? Gosu::GP_BUTTON_0
      move :up
    end
    if Gosu.button_down? Gosu::KB_DOWN or Gosu::button_down? Gosu::GP_BUTTON_1
      move :down
    end
  end

  def needs_render?
    true
  end

  def move(direction)
    if direction == :left
      @bounding_box.x -= @move_speed
    elsif direction == :right
      @bounding_box.x += @move_speed
    elsif direction == :up
      @bounding_box.y -= @move_speed
    else
      @bounding_box.y += @move_speed
    end
  end
end
