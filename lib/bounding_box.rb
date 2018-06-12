class BoundingBox
  attr_accessor :x, :y, :z, :w, :h

  def initialize(x, y, z, w, h)
    @x, @y, @z, @w, @h = x, y, z, w, h
  end
end
