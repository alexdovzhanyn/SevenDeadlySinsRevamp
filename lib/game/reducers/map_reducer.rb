class MapReducer < Rydux::Reducer
  @@initial_state = {
    valid_locations: []
  }

  def self.map_state(action, state = @@initial_state)
    case action[:type]
    when 'UPDATE_VALID_LOCATIONS'
      state.merge(valid_locations: action[:payload])
    else
      state
    end
  end

end
