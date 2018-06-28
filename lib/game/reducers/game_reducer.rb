class GameReducer < Rydux::Reducer
  @@initial_state = {
    settings: {
      gui_scale: 'Auto'
    }
  }


  def self.map_state(action, state = @@initial_state)
    case action[:type]
    when 'LOAD_TILES'
      state.merge(tiles: Gosu::Image.load_tiles('./assets/tiles/map_tiles.png', 16, 16, {retro: true})) # Retro means no weird border around smaller tiles)
    when 'SET_WINDOW'
      state.merge(window: action[:payload])
    when 'SET_SCENE'
      state.merge(scene: action[:payload].new)
    when 'UPDATE_SETTINGS'
      state.merge(settings: action[:payload])
    when 'SET_CURSOR'
      state.merge(cursor: action[:payload])
    when 'SET_LAST_CLICK'
      state.merge(last_click: action[:payload])
    else
      state
    end
  end

end
