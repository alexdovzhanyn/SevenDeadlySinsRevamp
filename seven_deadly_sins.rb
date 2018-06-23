require_relative 'initializer'

class SevenDeadlySins < Gosu::Window
  WIDTH, HEIGHT = 1920, 1080

  def initialize
    print_debug_info
    super WIDTH, HEIGHT
    self.caption = TITLE
    GameState.set_state(window: self)
    GameState.set_state(current_scene: TitleScene.new)
  end

  def update
    GameState.current_scene.update
  end

  def draw
    GameState.current_scene.draw
  end

  def needs_cursor?
    GameState.current_scene.needs_cursor?
  end

  def print_debug_info
    puts "Initialized window @#{WIDTH}x#{HEIGHT}"
    puts "Running ruby version #{RUBY_VERSION}"
  end
end

SevenDeadlySins.new.show
