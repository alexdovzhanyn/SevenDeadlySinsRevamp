class OptionsScene < Scene

  def initialize
    super

    @offset_x = @window.width * 0.05
    options = [
      { text: 'Video Options', action: ->(){ GameState.set_state(current_scene: MainMenuScene.new) } },
      { text: 'Audio Options', action: ->(){ GameState.set_state(current_scene: MainMenuScene.new) } },
      { text: 'Back to Menu', action: ->(){ GameState.set_state(current_scene: MainMenuScene.new) }}
    ]

    @clickspots = []

    @buttons = @window.record(@window.width, @window.height) do |x, y|
      options.each_with_index do |option, idx|
        Gosu.draw_rect(@offset_x - 4, idx * 74 + (@window.height * 0.1 + 174) + 5, 408, 64, 0x552a2735, 1)
        Gosu.draw_rect(@offset_x, idx * 74 + (@window.height * 0.1 + 174), 400, 64, 0xff2a2735, 2)
        Gosu.draw_rect(@offset_x + 4, idx * 74 + (@window.height * 0.1 + 174) + 4, 392, 56, 0xff57709c, 3)
        Gosu.draw_rect(@offset_x + 4, idx * 74 + (@window.height * 0.1 + 174) + 4, 388, 52, 0x22ffffff, 4)

        @clickspots << {x: @offset_x..(@offset_x + 400), y: (idx * 74 + (@window.height * 0.1 + 174))..(idx * 74 + (@window.height * 0.1 + 174) + 64), action: option[:action]}

        Gosu::Image.from_text(option[:text], 52,
          font: 'assets/fonts/8-bit-limit/8bitlim.ttf',
          align: :center,
          width: 400
        ).draw(@offset_x, idx * 74 + (@window.height * 0.1 + 174) + 3, 4)
      end
    end

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
          GameState.tiles[tile_idx].draw(x * 32, y * 32, 0, 2, 2)
        end
      end
    end
  end

  def draw
    @background.draw(0,0,0)
    @buttons.draw(0,0,1)
  end

  def update
    if Gosu.button_down?(Gosu::MS_LEFT) && Gosu.milliseconds > GameState.last_click.to_i + 200
      button = @clickspots.find {|spot| spot[:x].include?(@window.mouse_x) && spot[:y].include?(@window.mouse_y)}
      if button
        GameState.set_state(last_click: Gosu.milliseconds)
        button[:action].call
      end
    end
  end

end
