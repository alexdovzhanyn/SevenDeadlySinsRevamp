require_relative 'initializer'

class SevenDeadlySins < Gosu::Window
  def initialize
    super 1920, 1080
    self.caption = "Seven Deadly Sins"

    @player = Player.new(0,0,0,40,40)
    @tiles = Gosu::Image.load_tiles('./assets/tiles/map_tiles.png', 16, 16)
    puts @tiles.length
  end

  def update
    @player.update
  end

  def draw
    @player.draw
    x = 0
    y = 0
    @tiles.each do |tile|
      tile.draw(x, y, 1, 4, 4)
      x += 64
      if x >= 1472
        x = 0
        y += 64
      end
    end
  end
end

SevenDeadlySins.new.show
