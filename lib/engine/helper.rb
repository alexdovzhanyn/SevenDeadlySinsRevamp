module Helper

  # Checks to see whether range 1 contains all of the points in range 2
  def range_contains_range?(range1, range2)
    range2.all? {|r| range1.include? r}
  end

end
