class TitleScene < Scene

  def initialize
    super
    puts '[Show Title Screen]'
    puts "in title screen, #{Store.state.game.cursor}"
    @color = 0xff000000
  end

  def draw
    # puts Store.state.game.cursor
    # Gosu.draw_rect(0, 0, window.width, window.height, @color, 0)
    case Gosu.milliseconds
    when 500..3000
      Gosu::Image.from_text('SilverStream Studio Presents...', 128, {
        font: 'assets/fonts/8-bit-limit/8bitlim.ttf',
        align: :center,
        width: @window.width - @window.width * 0.3
      }).draw(@window.width * 0.15, @window.height * 0.3, 1)
    when 3800..5000
      Gosu::Image.from_text('Seven Deadly Sins', 128, {
        font: 'assets/fonts/8-bit-limit/8bitlim.ttf',
        align: :center,
        width: @window.width - @window.width * 0.3
      }).draw(@window.width * 0.15, @window.height * 0.3, 1)
    when 5001..6000
      puts '[End Tile Screen]'
      Store.dispatch(type: 'SET_SCENE', payload: MainMenuScene)
    end
  end

end
