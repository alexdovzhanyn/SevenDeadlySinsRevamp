require_relative 'initializer'

class SevenDeadlySins < Gosu::Window
  WIDTH, HEIGHT = 1920, 1080

  def initialize
    print_debug_info
    Store.subscribe{ [:game] }
    super WIDTH, HEIGHT
    self.caption = TITLE

    Store.dispatch('SET_WINDOW', self)
    Store.dispatch('SET_SCENE', TitleScene)
  end

  def update
    Store.state.game.scene.update
  end

  def draw
    Store.state.game.scene.draw
  end

  def needs_cursor?
    @needs_cursor
  end

  def state_changed(state)
    @needs_cursor = state.game.cursor
  end

  def print_debug_info
    puts "Initialized window @#{WIDTH}x#{HEIGHT}"
    puts "Running ruby version #{RUBY_VERSION}"
  end
end

SevenDeadlySins.new.show
