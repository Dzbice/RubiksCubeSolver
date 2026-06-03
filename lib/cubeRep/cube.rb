require_relative 'moves'
# represents the cube
#
class Cube
  include Moves
  attr_accessor :cube

  def initialize
    @cube = make_cube
  end

  def make_cube
    corners = (0..7).map { |x| x * 3 }
    edges = (0..11).map { |x| x * 2 }
    corners + edges
  end

  def get_orientation(index)
    return @cube[index] % 2 if index > 7

    @cube[index] % 3
  end

  def get_cubie(index)
    return @cube[index] / 2 if index > 7

    @cube[index] / 3
  end

  def moves(move)
    parse_moves(@cube, move)
  end
end
