class OptionsScene < Scene

  def initialize
    super

    puts '[Show Options]'

    options = [
      { text: 'Video Options', action: ->(){ Store.dispatch(type: 'SET_SCENE', payload: VideoSettingsScene) } },
      { text: 'Audio Options', action: ->(){ Store.dispatch(type: 'SET_SCENE', payload: MainMenuScene) } },
      { text: 'Back to Menu', action: ->(){ Store.dispatch(type: 'SET_SCENE', payload: MainMenuScene) }}
    ]

    @clickspots = []

    initialize_background
    initialize_buttons(options)
  end

  def draw
    @background.draw(0, 0, 0)
    @buttons.draw(0, 0, 1)
  end

  def state_changed(new_state, last_action)
    super(new_state, last_action)

    if last_action == 'SET_SCENE'
      Store.dispatch(type: 'SET_CURSOR', payload: true)
    end

  end


end
