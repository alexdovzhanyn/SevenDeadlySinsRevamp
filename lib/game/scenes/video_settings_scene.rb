class VideoSettingsScene < Scene

  def initialize
    super
    puts "[Show Video Settings]"

    @options = generate_options

    initialize_background
    initialize_buttons(@options)
  end

  def draw
    @background.draw(0, 0, 0)
    @buttons.draw(0, 0, 0)
  end

  def update
    super
  end

  def state_changed(new_state)
    super(new_state)

    @options = generate_options
    initialize_buttons(@options)
  end

  def change_gui_scale
    scale = Store.game.settings.gui_scale
    new_scale = scale

    if scale == 'Auto'
      new_scale = 'Small'
    elsif scale == 'Small'
      new_scale = 'Medium'
    elsif scale == 'Medium'
      new_scale = 'Large'
    else
      new_scale = 'Auto'
    end

    Store.dispatch(type: 'UPDATE_SETTINGS', payload: { gui_scale: new_scale })
  end

  def generate_options
    [
      { text: "GUI Scale: #{Store.game.settings.gui_scale}", action: ->{ change_gui_scale } },
      { text: "Back", action: ->{ Store.dispatch(type: 'SET_SCENE', payload: OptionsScene) } }
    ]
  end

end
