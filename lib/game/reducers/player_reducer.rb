class PlayerReducer < Rydux::Reducer
  @@initial_state = {}

  def self.map_state(action, state = @@initial_state)
    case action[:type]
    when 'HIT_EDGE'
      state.merge(edges_hit: action[:payload])
    else state
    end
  end

end
