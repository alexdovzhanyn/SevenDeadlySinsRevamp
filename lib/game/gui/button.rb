class Button

  def initialize(x, y, z, w, h, text, onclick = ->(){})
    @x, @y, @z, @w, @h, @text, @onclick = x, y, z, w, h, text, onclick
  end

  def draw
    Gosu.draw_rect(@x - 4, @y + 5, @w + 8, @h, 0x552a2735, @z + 1)
    Gosu.draw_rect(@x, @y, @w, @h, 0xff2a2735, @z + 2)
    Gosu.draw_rect(@x + 4, @y + 4, @w - 8, @h - 8, 0xff57709c, @z + 3)
    Gosu.draw_rect(@x + 4, @y + 4, @w - 12, @h - 12, 0x22ffffff, @z + 4)

    Gosu::Image.from_text(@text, @h - 12,
      font: 'assets/fonts/8-bit-limit/8bitlim.ttf',
      align: :center,
      width: @w
    ).draw(@x, @y + 3, 5)
  end

  def clickspots
    {x: @x..(@x + @w), y: @y..(@y + @h), action: @onclick}
  end

end
