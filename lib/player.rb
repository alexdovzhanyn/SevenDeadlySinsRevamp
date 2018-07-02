class Player < Humanoid
  include Observable
  HARD_EDGE = 300

  def initialize(*opts)
    @width, @height = 64, 64
    tiles = Store.game.tiles
    sprites = [tiles[152], tiles[153], tiles[175], tiles[176]]
    opts += [@width, @height, sprites]
    super(*opts)
    @window = Store.game.window
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
    if edges_hit.length == 0 || !edges_hit.include?(direction)
      super(direction)
    else
      Store.dispatch('HIT_EDGE', edges_hit)
    end
  end
end
