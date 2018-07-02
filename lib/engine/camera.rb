class Camera
  include Observable
  attr_reader :offset_x, :offset_y

  def initialize(player)
    Store.subscribe {[ :player ]}
    @offset_x, @offset_y = 0, 0
    @player_move_speed = player.move_speed
  end

  def state_changed(state)
    if state.edges_hit.include? :left
      @offset_x -= @player_move_speed
    elsif state.edges_hit.include? :right
      @offset_x += @player_move_speed
    end

    if state.edges_hit.include? :up
      @offset_y -= @player_move_speed
    elsif state.edges_hit.include? :down
      @offset_y += @player_move_speed
    end

    Store.dispatch('CAMERA_MOVED', { x: @offset_x, y: @offset_y })
  end

end
