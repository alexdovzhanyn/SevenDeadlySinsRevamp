require_relative 'initializer'

class LevelBuilder < Gosu::Window
  WIDTH, HEIGHT, TILE_SIZE, MENU_WIDTH, MENU_TILE_SIZE = 1920, 1080, 32, 400, 48

  def initialize
    super WIDTH, HEIGHT
    self.caption = "SDS Level Builder"
    @game_tiles = Gosu::Image.load_tiles('./assets/tiles/map_tiles.png', 16, 16, {retro: true}) # Retro means no weird border around smaller tiles
    @max_tiles_x, @max_tiles_y, @map = LevelMapper.generate_empty_map(WIDTH, HEIGHT, TILE_SIZE)
    @max_menu_tiles_x, @max_menu_tiles_y, _menu = LevelMapper.generate_empty_map(MENU_WIDTH, HEIGHT, 64)
    @mouse_left_down = false
    @current_z = 2
    load_menu
    @font = Gosu::Font.new(32)
  end

  def update
    if Gosu.button_down?(Gosu::MS_LEFT) && !@mouse_left_down
      @mouse_left_down = true
      tile_in_menu = @menu_tiles.find {|tile| mouse_x >= tile[:x] && mouse_x <= tile[:x] + MENU_TILE_SIZE - 1 && mouse_y >= tile[:y] && mouse_y <= tile[:y] + MENU_TILE_SIZE - 1}

      if tile_in_menu
        @tile_selected = tile_in_menu
      else
        clicked_map_location = @map.find_index {|tiles| tiles.any? {|tile| mouse_x >= tile[:x] + MENU_WIDTH && mouse_x <= tile[:x] + MENU_WIDTH + TILE_SIZE - 1 && mouse_y >= tile[:y] && mouse_y <= tile[:y] + TILE_SIZE - 1}}
        exact_tile_location = @map[clicked_map_location].find_index { |tile| tile[:z] == @current_z }

        if exact_tile_location
          if @tile_selected
            @map[clicked_map_location][exact_tile_location][:tile] = @tile_selected[:image]
            @map[clicked_map_location][exact_tile_location][:z] = @current_z
          else
            @map[clicked_map_location][exact_tile_location][:tile] = nil
          end
        elsif !exact_tile_location && @tile_selected
          ref = @map[clicked_map_location][0]
          @map[clicked_map_location] << {x: ref[:x], y: ref[:y], z: @current_z, tile: @tile_selected[:image]}
        end
      end
    elsif !Gosu.button_down?(Gosu::MS_LEFT) && @mouse_left_down
      @mouse_left_down = false
    elsif Gosu.button_down?(Gosu::KB_UP)
      @current_z += 1
    elsif Gosu.button_down?(Gosu::KB_DOWN)
      if @current_z - 1 > 1
        @current_z -= 1
      end
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
      @tile_selected[:image].draw(mouse_x, mouse_y, 9999, TILE_SIZE / 16, TILE_SIZE / 16)
    end
  end

  def needs_cursor?
    !@tile_selected ||= false
  end

  def load_menu
    x, y = 0, 0

    @menu_tiles = []

    @game_tiles.each do |tile|
      if x + MENU_TILE_SIZE - 1 >= MENU_WIDTH
        x = 0
        y += MENU_TILE_SIZE
      end

      @menu_tiles << {x: x, y: y, image: tile}

      x += MENU_TILE_SIZE
    end

    @menu_tiles
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
              ? 0xaa000000 : 0xff000000

    Gosu.draw_rect(tile[:x] + 1 + MENU_WIDTH, tile[:y] + 1, TILE_SIZE - 1, TILE_SIZE - 1, color, 1)
    if tile[:tile]
      color = color == 0xaa000000 ? 0xaaffffff : 0xffffffff
      tile[:tile].draw(tile[:x] + MENU_WIDTH, tile[:y], tile[:z], TILE_SIZE / 16, TILE_SIZE / 16, color)
    end
  end
end

LevelBuilder.new.show
