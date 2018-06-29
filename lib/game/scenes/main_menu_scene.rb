class MainMenuScene < Scene

  def initialize
    super

    puts '[Show Main Menu]'

    options = [
      { text: 'New Game', action: ->(){ start_new_game } },
      { text: 'Options', action: ->(){ Store.dispatch('SET_SCENE', OptionsScene) } },
      { text: 'Exit to Desktop', action: ->(){ exit }}
    ]

    @clickspots = []

    initialize_background
    initialize_buttons(options)
  end

  def draw
    @background.draw(0, 0, 0)

    title = Gosu::Image.from_text('Seven Deadly Sins', 64, {
      font: 'assets/fonts/8-bit-limit/8bitlim.ttf',
      align: :left,
      width: @window.width - @window.width * 0.3
    })

    title.draw(@offset_x, @window.height * 0.1, 2)

    title.draw(@offset_x, @window.height * 0.1 + 5, 1, 1, 1, 0xaa000000)

    @buttons.draw(0, 0, 1)
  end

  def start_new_game
    Store.dispatch('SET_SCENE', GameScene, ->{
      Store.dispatch('SET_CURSOR', false, ->{
        locations = Store.game.scene.level_mapper.find_valid_player_locations
        Store.game.scene.level_mapper.set_valid_player_locations(locations)
      })
    })
  end

end
