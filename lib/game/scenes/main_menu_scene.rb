class MainMenuScene < Scene

  def initialize
    super

    puts '[Show Main Menu]'

    options = [
      { text: 'New Game', action: ->(){ Store.dispatch(type: 'SET_SCENE', payload: GameScene) } },
      { text: 'Options', action: ->(){ Store.dispatch(type: 'SET_SCENE', payload: OptionsScene) } },
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

  def state_changed(new_state, last_action)
    super(new_state, last_action)

    if last_action == 'SET_SCENE'
      Store.dispatch(type: 'SET_CURSOR', payload: true)
    end

  end

end
