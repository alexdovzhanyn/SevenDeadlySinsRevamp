class LevelMapper
  TILE_SIZE = 32
  HARD_EDGE = 300

  def initialize(mapfile, camera)
    Store.subscribe {[ :camera ]}
    @window, @sprites = Store.game.window, Store.game.tiles
    @map = initialize_mapfile(mapfile)
    @font = Gosu::Font.new(16)
    @offset_x, @offset_y = 0, 0
    @tiles_within_viewport = @map.select {|tileset| within_viewport?(tileset[0]['x'], tileset[0]['y'])}

    # Pre-record map so that we can speed up rendering.
    create_static_recording
  end

  def state_changed(state)
    @offset_x, @offset_y = state.x, state.y
  end

  def update
    # Chunk tile loads so that we aren't reloading @tiles_within_viewport every time the offset changes
    if @offset_x > 0 && @offset_x % HARD_EDGE == 0 || @offset_y > 0 && @offset_y % HARD_EDGE == 0
      @tiles_within_viewport = @map.select {|tileset| within_viewport?(tileset[0]['x'], tileset[0]['y'])}
      create_static_recording
    end

    find_valid_player_locations
  end

  def draw
    @map_rec.draw(0 - @offset_x, 0 - @offset_y, 0)
  end

  def initialize_mapfile(mapfile)
    contents = File.read(File.join(File.dirname(__FILE__), '..', '..', 'assets', 'maps', mapfile))
    JSON.parse(contents)
  end

  def self.generate_empty_map(width, height, tile_size)
    max_tiles_x, max_tiles_y = width / tile_size * 6, height / tile_size * 6
    generated_map = (0..max_tiles_y).map {|y| (0..max_tiles_x).map {|x| [{x: x * tile_size, y: y * tile_size, z: 2}]}}.flatten(1)
    [max_tiles_x, max_tiles_y, generated_map]
  end

  def within_viewport?(x, y)
    x - @offset_x - HARD_EDGE - 150 <= @window.width && y - @offset_y - HARD_EDGE - 150 <= @window.height
  end

  def valid_location?(tileset)
    !!tileset.find {|tile| tile['valid_location']}
  end

  # TODO: This is kind of gross... find a better way to generate these. Maybe chunk them?
  def find_valid_player_locations
    # Array of arrays of ranges [[0..2, 10..12], [3..7, 9..23]]
    locations = @tiles_within_viewport.select {|tileset| valid_location? tileset}.map {|tileset| [((tileset[0]['x'] - @offset_x)..(tileset[0]['x'] - @offset_x + TILE_SIZE)), ((tileset[0]['y'] - @offset_y)..(tileset[0]['y'] - @offset_y + TILE_SIZE))]}

    newLocations = []

    # Some ranges may pick up where others left off. These should be concatenated into one big range
    locations.each do |location|
      if newLocations.last && location[0].begin == newLocations.last[0].end && location[1] == newLocations.last[1]
        newLocations.last[0] = (newLocations.last[0].begin..location[0].end)
      elsif newLocations.last && location[1].begin == newLocations.last[1].end && location[0] == newLocations.last[0]
        newLocations.last[1] = (newLocations.last[1].begin..location[1].end)
      else
        newLocations << location.clone
      end
    end

    newLocations
  end

  def create_static_recording
    @map_rec = @window.record(@window.width, @window.height) do |x, y|
      @tiles_within_viewport.each do |tiles|
        tiles.each do |tile|
          Gosu.draw_rect(tile['x'], tile['y'], TILE_SIZE, TILE_SIZE, 0xff292634, 1)
          if tile['valid_location']
            # Gosu.draw_rect(tile['x'], tile['y'], TILE_SIZE, TILE_SIZE, 0x7700ff00, tile['z'])
          elsif tile['sprite_index']
            @sprites[tile['sprite_index']].draw(tile['x'], tile['y'], tile['z'], TILE_SIZE / 16, TILE_SIZE / 16)
          end
        end
      end
    end
  end

  def set_valid_player_locations(locations)
    Store.dispatch('UPDATE_VALID_LOCATIONS', locations)
  end
end
