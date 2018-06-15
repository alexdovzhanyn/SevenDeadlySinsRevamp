require_relative 'initializer'

class LevelBuilder < Gosu::Window
  WIDTH, HEIGHT, TILE_SIZE, MENU_WIDTH, MENU_TILE_SIZE = 1920, 1150, 32, 400, 48

  def initialize
    super WIDTH, HEIGHT
    self.caption = "SDS Level Builder"
    @game_tiles = Gosu::Image.load_tiles('./assets/tiles/map_tiles.png', 16, 16, {retro: true}) # Retro means no weird border around smaller tiles
    @max_tiles_x, @max_tiles_y, @map = LevelMapper.generate_empty_map(WIDTH, HEIGHT, TILE_SIZE)
    @mouse_left_down = false
    @current_z = 2
    load_menu
    @font = Gosu::Font.new(32)
  end

  def update
    # mouse_left down var lets us know only the first time the mouse clicks
    # otherwise we'd get a stream of click events as long as the mouse is held
    if Gosu.button_down?(Gosu::MS_LEFT) && !@mouse_left_down
      @mouse_left_down = true

      # Is the clicked area a tile in the menu?
      tile_in_menu = @menu_tiles.find {|tile| mouse_x >= tile[:x] && mouse_x <= tile[:x] + MENU_TILE_SIZE - 1 && mouse_y >= tile[:y] && mouse_y <= tile[:y] + MENU_TILE_SIZE - 1}

      if tile_in_menu
        @tile_selected = tile_in_menu
      else
        # Menu wasn't clicked. User clicked somewhere on the map. Which tileset is in the area clicked?
        clicked_map_location = @map.find_index {|tiles| tiles.any? {|tile| mouse_x >= tile[:x] + MENU_WIDTH && mouse_x <= tile[:x] + MENU_WIDTH + TILE_SIZE + 1 && mouse_y >= tile[:y] && mouse_y <= tile[:y] + TILE_SIZE + 1}}

        # We have a z-index. Let's use it to find the exact tile within the tileset in this location
        exact_tile_location = @map[clicked_map_location].find_index { |tile| tile[:z] == @current_z }

        # There may or may not be a tile with the z-index we're currently using
        if exact_tile_location
          # If clicked on a map tile and we have a selected sprite, set the sprite in that location
          if @tile_selected
            @map[clicked_map_location][exact_tile_location][:tile] = @tile_selected[:image]
            @map[clicked_map_location][exact_tile_location][:z] = @current_z
            @map[clicked_map_location][exact_tile_location][:sprite_index] = @tile_selected[:sprite_index]
          else
            # No selected sprite = delete tile in selected location
            @map[clicked_map_location][exact_tile_location][:tile] = nil
            @map[clicked_map_location][exact_tile_location][:sprite_index] = nil
          end
        elsif !exact_tile_location && @tile_selected
          # We don't have a tile with the z-index in the tileset we've selected, so lets append a new one to the array
          ref = @map[clicked_map_location][0]
          @map[clicked_map_location] << {x: ref[:x], y: ref[:y], z: @current_z, tile: @tile_selected[:image], sprite_index: @tile_selected[:sprite_index]}
        end
      end
    elsif !Gosu.button_down?(Gosu::MS_LEFT) && @mouse_left_down
      @mouse_left_down = false
    elsif Gosu.button_down?(Gosu::MS_RIGHT)
      @tile_selected = nil
    elsif Gosu.button_down?(Gosu::KB_UP)
      @current_z += 1
    elsif Gosu.button_down?(Gosu::KB_DOWN)
      if @current_z - 1 > 1
        @current_z -= 1
      end
    elsif Gosu.button_down?(Gosu::KB_LEFT_SHIFT) && Gosu.button_down?(Gosu::KB_S)
      tmp = @map.map {|tiles| tiles.map {|tile| {x: tile[:x], y: tile[:y], z: tile[:z], sprite_index: tile[:sprite_index]}}}.to_json
      File.write(File.join(File.dirname(__FILE__), 'assets', 'maps', 'test.json'), tmp)
      puts "Saved!"
    end
  end

  def draw
    draw_menu
    draw_map
    draw_cursor
    @font.draw("Z-Index: #{@current_z}", MENU_WIDTH + 50, 50, 9998)
  end

  def draw_cursor
    if @tile_selected
      @tile_selected[:image].draw(mouse_x - TILE_SIZE / 2, mouse_y - TILE_SIZE / 2, 9999, TILE_SIZE / 16, TILE_SIZE / 16)
    end
  end

  def needs_cursor?
    !@tile_selected ||= false
  end

  def load_menu
    @menu_tiles = []
    x, y = 10, 10

    @game_tiles.each_with_index do |tile, i|
      if x + MENU_TILE_SIZE - 1 >= MENU_WIDTH
        x = 10
        y += MENU_TILE_SIZE
      end

      @menu_tiles << {x: x, y: y, image: tile, sprite_index: i}
      x += MENU_TILE_SIZE
    end
  end

  def draw_menu
    @menu_tiles.each do |tile|
      color = mouse_x >= tile[:x] && mouse_x <= tile[:x] + MENU_TILE_SIZE - 1 && mouse_y >= tile[:y] && mouse_y <= tile[:y] + MENU_TILE_SIZE - 1 ? 0xaaffffff : 0xffffffff
      tile[:image].draw(tile[:x], tile[:y], 1, MENU_TILE_SIZE / 16 - 0.2, MENU_TILE_SIZE / 16 - 0.2, color)
    end
  end

  def draw_map
    Gosu.draw_rect(0, 0, (@max_tiles_x * TILE_SIZE) + MENU_WIDTH, @max_tiles_y * TILE_SIZE, 0xffffffff, 0)

    @map.each do |tiles|
      tiles.each{|tile| draw_tile(tile)}
    end
  end

  def draw_tile(tile)
    color = mouse_x >= tile[:x] + MENU_WIDTH \
            && mouse_x <= tile[:x] + MENU_WIDTH + TILE_SIZE - 1 \
            && mouse_y >= tile[:y] && mouse_y <= tile[:y] + TILE_SIZE - 1 \
              ? 0xaa000000 : 0xff263f5a

    # No need to draw all 17,000 tiles...
    if within_viewport?(tile[:x], tile[:y], TILE_SIZE, TILE_SIZE)
      Gosu.draw_rect(tile[:x] + 1 + MENU_WIDTH, tile[:y] + 1, TILE_SIZE - 1, TILE_SIZE - 1, color, 1)
      if tile[:tile]
        color = color == 0xaa000000 ? 0xaaffffff : 0xffffffff
        tile[:tile].draw(tile[:x] + MENU_WIDTH, tile[:y], tile[:z], TILE_SIZE / 16, TILE_SIZE / 16, color)
      end
    end
  end

  def within_viewport?(x, y, w = 0, h = 0)
    x + w <= WIDTH && y + h <= HEIGHT
  end
end

LevelBuilder.new.show
