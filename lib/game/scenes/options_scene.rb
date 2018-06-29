class OptionsScene < Scene

  def initialize
    super

    puts '[Show Options]'

    options = [
      { text: 'Video Options', action: ->(){ Store.dispatch('SET_SCENE', VideoSettingsScene) } },
      { text: 'Audio Options', action: ->(){ Store.dispatch('SET_SCENE', MainMenuScene) } },
      { text: 'Back to Menu', action: ->(){ Store.dispatch('SET_SCENE', MainMenuScene) }}
    ]

    @clickspots = []

    initialize_background
    initialize_buttons(options)
  end

  def draw
    @background.draw(0, 0, 0)
    @buttons.draw(0, 0, 1)
  end

end
