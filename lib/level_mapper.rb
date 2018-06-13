class LevelMapper
  attr_accessor :tiles

  TILE_SIZE = 64

  def initialize(window, mapfile, sprites)
    @window = window
    @sprites = sprites
    @map_tiles = read_tile_map(mapfile)
    @max_tiles_x = (@window.width / TILE_SIZE) + 1
    @max_tiles_y = (@window.height / TILE_SIZE) + 1
    @map = Array.new(@max_tiles_y, Array.new(@max_tiles_x))
    @font = Gosu::Font.new(16)
  end

  def update
    @map = @map.map.with_index do |row, y|
      row.map.with_index do |tile, x|
        @map_tiles[y] ? @map_tiles[y][x] ? @map_tiles[y][x] : @map[y][x] : @map[y][x]
      end
    end
  end

  def draw
    x = 0
    y = 0

    if true
      x, y = render_debug_tilemap(x, y)
    end

    @map.each_with_index do |map_row, row_index|
      map_row.each_with_index do |map_tile, tile_index|
        Gosu.draw_rect(x, y, TILE_SIZE, TILE_SIZE, 0xff292634, 0)
        if map_tile == nil
          x += TILE_SIZE
          next
        end
        @sprites[@map[row_index][tile_index]].draw(x, y, 1, TILE_SIZE / 16, TILE_SIZE / 16)
        x += TILE_SIZE
      end

      x = 0
      y += TILE_SIZE
    end
  end

  def needs_render?
    true
  end

  def read_tile_map(mapfile)
    File.open(File.join(File.dirname(__FILE__), '..', 'assets', 'maps', mapfile)).map do |row|
      row.gsub(/\s/, "").split(",").map do |tile|
        tile == 'nil' ? nil : tile.to_i
      end
    end
  end

  def render_debug_tilemap(x, y)
    @sprites.each_with_index do |tile, i|
      @font.draw(i, x, y, 2)
      tile.draw(x, y, 1, TILE_SIZE / 16, TILE_SIZE / 16)
      x += TILE_SIZE
      if x >= @window.width
        x = 0
        y += TILE_SIZE
      end
    end

    [0, y + TILE_SIZE]
  end
end
