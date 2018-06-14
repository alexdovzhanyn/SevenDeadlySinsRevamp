class LevelMapper
  attr_accessor :tiles

  TILE_SIZE = 32

  def initialize(window, mapfile, sprites)
    @window = window
    @sprites = sprites
    @map = initialize_mapfile(mapfile)
    @font = Gosu::Font.new(16)
  end

  def update
  end

  def draw
    @map.each do |tiles|
      tiles.each{|tile| draw_tile(tile)}
    end
  end

  def draw_tile(tile)
    Gosu.draw_rect(tile['x'], tile['y'], TILE_SIZE, TILE_SIZE, 0xff292634, 1)
    if tile['sprite_index']
      @sprites[tile['sprite_index']].draw(tile['x'], tile['y'], tile['z'], TILE_SIZE / 16, TILE_SIZE / 16)
    end
  end

  def needs_render?
    true
  end

  def initialize_mapfile(mapfile)
    contents = File.read(File.join(File.dirname(__FILE__), '..', 'assets', 'maps', mapfile))
    JSON.parse(contents)
  end

  def self.generate_empty_map(width, height, tile_size)
    max_tiles_x, max_tiles_y = width / tile_size * 6, height / tile_size * 6
    generated_map = (0..max_tiles_y).map {|y| (0..max_tiles_x).map {|x| [{x: x * tile_size, y: y * tile_size, z: 2}]}}.flatten(1)
    [max_tiles_x, max_tiles_y, generated_map]
  end
end
