class GameScene < Scene

  def initialize
    super
    @player = Player.new(@window.width / 2 - 16, @window.height / 2 - 32, 100)
    @camera = Camera.new(@player)
    @level_mapper = LevelMapper.new('test.json', @camera)
    @player.bounding_box.x = GameState.valid_locations[0][0].to_a[0]
    @player.bounding_box.y = (GameState.valid_locations[0][1].to_a[0] - @player.bounding_box.h) + 48
  end

  def update
    @player.update
    @level_mapper.update
  end

  def draw
    @player.draw
    @level_mapper.draw
  end

end
