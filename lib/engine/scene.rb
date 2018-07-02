class Scene

  def initialize
    Store.subscribe(self)
    @window = Store.game.window
    @clickspots = []
    @offset_x = @window.width * 0.05
    @tiles = Store.game.tiles
  end

  def draw

  end

  def update
    # Gosu.milliseconds eventually wraps. This will become a problem is the game runs for a while
    if @buttons && Gosu.button_down?(Gosu::MS_LEFT) && Gosu.milliseconds > (Store.game.last_click || 0) + 200
      button = @clickspots.find {|spot| spot[:x].include?(@window.mouse_x) && spot[:y].include?(@window.mouse_y)}
      if button
        Store.dispatch('SET_LAST_CLICK', Gosu.milliseconds)
        button[:action].call
      end
    end
  end

  def initialize_background
    @background = @window.record(@window.width, @window.height) do
      (@window.width / 32 + 1).times do |x|
        (@window.height / 32 + 1).times do |y|

          if y == @window.height / 32
            tile_idx = rand(162..164)
          elsif y == @window.height / 32 - 1
            tile_idx = rand(139..141)
          else
            tile_idx = rand(116..118)
          end
          @tiles[tile_idx].draw(x * 32, y * 32, 0, 2, 2)
        end
      end
    end
  end

  def initialize_buttons(buttons)
    @buttons = @window.record(@window.width, @window.height) do |x, y|
      buttons.each_with_index do |option, idx|
        button = Button.new(@offset_x, idx * 74 + (@window.height * 0.1 + 174), 1, 400, 64, option[:text], option[:action])
        @clickspots << button.clickspots
        button.draw
      end
    end
  end

  def state_changed(new_state)
    @tiles = new_state.game.tiles
  end

end
