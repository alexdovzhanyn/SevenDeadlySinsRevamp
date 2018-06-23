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
    return if !moving_to_valid_location?(direction)

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

  def moving_to_valid_location?(direction)
    direction_modifier_x = if direction == :left then -self.move_speed elsif direction == :right then self.move_speed else 0 end
    direction_modifier_y = if direction == :up then -self.move_speed elsif direction == :down then self.move_speed else 0 end
    potential_x = ((bounding_box.x + 2) + direction_modifier_x)..((bounding_box.x - 2) + bounding_box.w + direction_modifier_x)
    potential_y = (bounding_box.y + bounding_box.h + direction_modifier_y)..(bounding_box.y + bounding_box.h + direction_modifier_y)

    GameState.valid_locations.any? {|location| range_contains_range?(location[0], potential_x) && range_contains_range?(location[1], potential_y)}
  end
end
