class Humanoid
  attr_reader :bounding_box, :move_speed

  def initialize(x, y, z, w, h, move_speed = 5)
    @move_speed = move_speed
    @bounding_box = BoundingBox.new(x, y, z, w, h)
    spritemap = generate_spritemap
  end

  def draw
    if needs_render?
      Gosu.draw_rect(bounding_box.x, bounding_box.y, bounding_box.w, bounding_box.h, Gosu::Color::RED, bounding_box.z)

    end
  end

  def update

  end

  def needs_render?
    true
  end

  def generate_spritemap
    rows, cols = bounding_box.h / 32 - 1, bounding_box.w / 32 - 1
    (0..rows).map {|y| (0..cols).map {|x| [{x: bounding_box.x + x * 32, y: bounding_box.y + y * 32, z: bounding_box.z}]}}
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
