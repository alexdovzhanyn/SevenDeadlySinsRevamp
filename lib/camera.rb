class Camera
  include Observable
  attr_reader :offset_x, :offset_y

  def initialize(window, player)
    @offset_x, @offset_y = 0, 0
    @window = window
    @player_move_speed = player.move_speed

    player.add_observer(self, :player_hit_hard_edge)
  end

  def player_hit_hard_edge(edges)
    if edges.include? :left
      @offset_x -= @player_move_speed
    elsif edges.include? :right
      @offset_x += @player_move_speed
    end

    if edges.include? :up
      @offset_y -= @player_move_speed
    elsif edges.include? :down
      @offset_y += @player_move_speed
    end

    changed
    notify_observers(@offset_x, @offset_y)
  end

end
