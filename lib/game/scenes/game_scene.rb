class GameScene < Scene
  attr_accessor :level_mapper

  def initialize
    super
    puts "[Show Game Scene]"
    @player = Player.new(@window.width / 2 - 16, @window.height / 2 - 32, 100)
    @camera = Camera.new(@player)
    @level_mapper = LevelMapper.new('test.json', @camera)
  end

  def update
    super
    @player.update
    @level_mapper.update
  end

  def draw
    @player.draw
    @level_mapper.draw
  end

end
