class Humanoid
  attr_reader :bounding_box, :move_speed

  def initialize(x, y, z, w, h, sprites, move_speed = 2)
    @move_speed = move_speed
    @bounding_box = BoundingBox.new(x, y, z, w, h)
    @sprites = sprites
    @spritemap = generate_spritemap
  end

  def draw
    if needs_render?
      @spritemap.each do |row|
        row.each do |tiles|
          tiles.each do |tile|
            # Gosu.draw_rect(@bounding_box.x + tile[:x], @bounding_box.y + tile[:y], 32, 32, Gosu::Color::RED, @bounding_box.z - 1)
            tile[:image].draw(@bounding_box.x + tile[:x], @bounding_box.y + tile[:y], @bounding_box.z, 32 / 16, 32 / 16)
          end
        end
      end
    end
  end

  def update

  end

  def needs_render?
    true
  end

  def generate_spritemap
    rows, cols = bounding_box.h / 32 - 1, bounding_box.w / 32 - 1
    (0..rows).map {|y| (0..cols).map {|x| [{x: x * 32, y: y * 32, z: bounding_box.z, image: @sprites[x + (y * 2)]}]}}
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
