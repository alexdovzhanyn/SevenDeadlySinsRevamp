class Player < Humanoid
  include Observable
  HARD_EDGE = 300

  def initialize(window, game_tiles, game_state, *opts)
    @width, @height = 64, 64
    sprites = [game_tiles[152], game_tiles[153], game_tiles[175], game_tiles[176]]
    opts += [@width, @height, sprites]
    super(*opts)
    @window = window
    @game_state = game_state
  end

  def update
    super

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

  def edges_hit
    edges = []
    if bounding_box.x <= HARD_EDGE
      edges << :left
      bounding_box.x = HARD_EDGE
    elsif bounding_box.x >= @window.width - HARD_EDGE
      edges << :right
      bounding_box.x = @window.width - HARD_EDGE
    end

    if bounding_box.y <= HARD_EDGE
      edges << :up
      bounding_box.y = HARD_EDGE
    elsif bounding_box.y >= @window.height - HARD_EDGE
      edges << :down
      bounding_box.y = @window.height - HARD_EDGE
    end

    edges
  end

  def move(direction)
    return if !moving_to_valid_location?(direction)

    if edges_hit.length == 0 || !edges_hit.include?(direction)
      super(direction)
    else
      changed
      notify_observers(edges_hit)
    end
  end

  def moving_to_valid_location?(direction)
    direction_modifier_x = if direction == :left then -self.move_speed elsif direction == :right then self.move_speed else 0 end
    direction_modifier_y = if direction == :up then -self.move_speed elsif direction == :down then self.move_speed else 0 end
    potential_x = ((bounding_box.x + 2) + direction_modifier_x)..((bounding_box.x - 2) + bounding_box.w + direction_modifier_x)
    potential_y = (bounding_box.y + bounding_box.h + direction_modifier_y)..(bounding_box.y + bounding_box.h + direction_modifier_y)

    @game_state[:valid_locations].any? {|location| range_contains_range?(location[0], potential_x) && range_contains_range?(location[1], potential_y)}
  end

  def range_contains_range?(range1, range2)
    range2.all? {|r| range1.include? r}
  end
end
