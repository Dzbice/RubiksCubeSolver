# module for cube moves
module Moves
  MOVES_TABLE = {
    'U' => [[0, 1, 2, 3], [8, 9, 10, 11], [0, 0, 0, 0], [0, 0, 0, 0]],
    'D' => [[4, 5, 6, 7],  [12, 13, 14, 15],  [0, 0, 0, 0], [0, 0, 0, 0]],
    'F' => [[3, 2, 6, 7],  [10, 18, 14, 19],  [2, 1, 2, 1], [1, 1, 1, 1]],
    'B' => [[0, 4, 5, 1],  [0, 16, 12, 17],   [2, 1, 2, 1], [1, 1, 1, 1]],
    'L' => [[0, 4, 7, 3],  [3, 16, 15, 19],   [1, 2, 1, 2], [0, 0, 0, 0]],
    'R' => [[1, 5, 6, 2],  [1, 17, 13, 18],   [2, 1, 2, 1], [0, 0, 0, 0]]
  }

  INVERSE = {
    'U\'!' => 'U',
    'D\'!' => 'D',
    'F\'!' => 'F',
    'B\'!' => 'B',
    'L\'!' => 'L',
    'R\'!' => 'R'
  }
  DOUBLE = {
    'U2' => 'U',
    'D2' => 'D',
    'F2' => 'F',
    'B2' => 'B',
    'L2' => 'L',
    'R2' => 'R'
  }

  def apply_move(cube, move)
    edge_move(cube, move)
    corner_move(cube, move)
    edge_orient(cube, move)
    corner_orient(cube, move)
  end

  def corner_move(cube, move)
    arr = MOVES_TABLE[move][0]
    tmp = cube[arr[3]]
    (0..2).reverse_each do |i|
      cube[arr[i + 1]] = cube[arr[i]]
    end
    cube[arr[0]] = tmp
  end

  def edge_move(cube, move)
    MOVES_TABLE[move][1]
    arr = MOVES_TABLE[move][1]
    tmp = cube[arr[3]]
    (0..2).reverse_each do |i|
      cube[arr[i + 1]] = cube[arr[i]]
    end
    cube[arr[0]] = tmp
  end

  def edge_orient(cube, move)
    moved_pieces = MOVES_TABLE[move][1]
    MOVES_TABLE[move][3].each_with_index do |x, i|
      piece = cube[moved_pieces[i]]
      cube[moved_pieces[i]] = (piece / 2) * 2 + ((piece % 2 + x) % 2)
      # piece/3*3 decodes the piece to be itself without orientation, then we add that on
    end
  end

  def corner_orient(cube, move)
    moved_pieces = MOVES_TABLE[move][0]
    MOVES_TABLE[move][2].each_with_index do |x, i|
      piece = cube[moved_pieces[i]]
      cube[moved_pieces[i]] = (piece / 3) * 3 + ((piece % 3 + x) % 3)
      # piece/3*3 decodes the piece to be itself without orientation, then we add that on
    end
  end

  def double_move(cube, move)
    2.times { apply_move(cube, move) }
  end

  def inverse_move(cube, move)
    3.times { apply_move(cube, move) }
  end

  def parse_move(cube, move)
    if move.end_with?("'")
      inverse_move(cube, move[0])
    elsif move.end_with?('2')
      double_move(cube, move[0])
    else
      apply_move(cube, move)
    end
  end

  def parse_moves(cube, moves)
    arr = moves.split(' ')
    arr.each { |x| parse_move(cube, x) }
  end
end
