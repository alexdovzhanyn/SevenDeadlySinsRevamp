class CameraReducer < Rydux::Reducer
  @@initial_state = {}

  def self.map_state(action, state = @@initial_state)
    case action[:type]
    when 'CAMERA_MOVED'
      state.merge(x: action[:payload][:x], y: action[:payload][:y])
    else state
    end
  end

end
