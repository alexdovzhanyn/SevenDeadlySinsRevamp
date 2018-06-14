class LevelMapper
  attr_accessor :tiles

  TILE_SIZE = 64

  def initialize(window, mapfile, sprites)
    @window = window
    @sprites = sprites
    @map_tiles = read_tile_map(mapfile)
    _a, _b, @map = self.class.generate_empty_map(@window.width, @window.height, TILE_SIZE)
    binding.pry
    @font = Gosu::Font.new(16)
  end

  def update
    @map = @map.map.with_index do |row, y|
      row.map.with_index do |tile, x|
        @map_tiles.select {|maptile| maptile["row"] == y && maptile["column"] + 10 == x}
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
      map_row.each_with_index do |map_tiles, tile_index|
        Gosu.draw_rect(x, y, TILE_SIZE, TILE_SIZE, 0xff292634, 0)
        if map_tiles == nil
          x += TILE_SIZE
          next
        end

        map_tiles.each do |tile|
          @sprites[tile["tile"]].draw(x, y, tile["z"], TILE_SIZE / 16, TILE_SIZE / 16)
        end

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
    contents = File.read(File.join(File.dirname(__FILE__), '..', 'assets', 'maps', mapfile))
    JSON.parse(contents)["map"]
  end

  def render_debug_tilemap(x, y)
    @sprites.each_with_index do |tile, i|
      if x >= @window.width
        x = 0
        y += TILE_SIZE
      end

      @font.draw(i, x, y, 2)
      tile.draw(x, y, 1, TILE_SIZE / 16, TILE_SIZE / 16)
      x += TILE_SIZE
    end

    [0, y + TILE_SIZE]
  end

  def self.generate_empty_map(width, height, tile_size)
    max_tiles_x, max_tiles_y = width / tile_size * 6, height / tile_size * 6

    generated_map = (0..max_tiles_y).map {|y| (0..max_tiles_x).map {|x| [{x: x * tile_size, y: y * tile_size, z: 2}]}}.flatten(1)

    [max_tiles_x, max_tiles_y, generated_map]
  end
end
