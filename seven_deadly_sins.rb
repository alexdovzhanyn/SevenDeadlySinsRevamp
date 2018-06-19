require_relative 'initializer'

class SevenDeadlySins < Gosu::Window
  WIDTH, HEIGHT = 1920, 1080

  def initialize
    print_debug_info
    @game_tiles = Gosu::Image.load_tiles('./assets/tiles/map_tiles.png', 16, 16, {retro: true}) # Retro means no weird border around smaller tiles
    super WIDTH, HEIGHT
    self.caption = "Seven Deadly Sins"
    @player = Player.new(self, @game_tiles, WIDTH / 2 - 16, HEIGHT / 2 - 32, 100)
    @camera = Camera.new(self, @player)
    @level_mapper = LevelMapper.new(self, 'test.json', @game_tiles, @camera)
  end

  def update
    @player.update
    @level_mapper.update
  end

  def draw
    @player.draw
    @level_mapper.draw
  end

  def print_debug_info
    puts "Initialized window @#{WIDTH}x#{HEIGHT}"
    puts "Running ruby version #{RUBY_VERSION}"
  end
end

SevenDeadlySins.new.show
