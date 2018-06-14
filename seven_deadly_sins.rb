require_relative 'initializer'

class SevenDeadlySins < Gosu::Window
  WIDTH, HEIGHT = 1920, 1080

  def initialize
    super WIDTH, HEIGHT
    self.caption = "Seven Deadly Sins"

    @player = Player.new(0,0,10,40,40)
    @game_tiles = Gosu::Image.load_tiles('./assets/tiles/map_tiles.png', 16, 16, {retro: true}) # Retro means no weird border around smaller tiles

    @level_mapper = LevelMapper.new(self, 'test.json', @game_tiles)
    @map_tiles = @level_mapper.tiles
  end

  def update
    # puts Gosu.fps
    @player.update
    @level_mapper.update
  end

  def draw
    @player.draw
    @level_mapper.draw
  end
end

SevenDeadlySins.new.show
