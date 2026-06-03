require_relative '../cubeRep/cube'
require_relative '../dataStruct/queue'
require_relative '../cubeRep/moves'
require_relative '../dataStruct/tree_node'
require_relative '../dataStruct/list_node'
class CornerPatternDb
  include Moves
  BITS = (0..2**8 - 1).map { |x| x.to_s(2).count('1') }
  FACTORIALS = (0..8).map { |n| (1..n).reduce(1, :*) }
  def initialize
    @moves = make_moves
    @solved_arr = Cube.new.cube
    @table = Array.new(88_179_840, -1)
    @table[encode(@solved_arr[0..7])] = 0
  end

  def make_moves
    base_moves = %w[R L U D F B]
    moves = []
    base_moves.each do |x|
      moves << x
      moves << "#{x}'"
      moves << "#{x}2"
    end
    moves
  end

  def makeDB
    count = 0
    queue = Queue.new
    node = TreeNode.new(@solved_arr.dup, '', 0)
    queue.push(node)
    until queue.empty?
      node = queue.pop.value
      addMoves(queue, node)
      count += 1
      if (count % 10_000).zero?
        puts "So far: #{count} |  depth is: #{node.depth} |  queue is: #{queue.size} elements rn"
      end
    end
  end

  def addMoves(queue, node)
    @moves.each do |move|
      last = node.sequence.split(' ').last
      # Doing R twice or R and then R' is redundant since that could've been done in 0-1 moves
      next if last && move[0] == last[0]

      # opposites are communative so does them in same order to save time
      next if last && Moves::OPPOSITE[move[0]] == last[0] && move[0] > last[0]

      new_state = node.state.dup
      parse_move(new_state, move)
      corner_state = new_state[0..7]
      next if @table[encode(corner_state)] != -1

      newnode = TreeNode.new(new_state, "#{node.sequence} #{move}", node.depth + 1)
      @table[encode(corner_state)] = newnode.depth
      queue.push(newnode)
    end
  end

  def lehmer(size, state)
    lehmer = 0

    mask = 0
    state.each_with_index do |x, i|
      id = x / 3
      lehmer += BITS[~mask & ((1 << id) - 1)] * FACTORIALS[7 - i]
      # basically we make a bitmask for everything below id, we check what we haven't see
      # see how many is in there, then get our weighing
      mask |= (1 << id)
    end
    lehmer
  end

  # orientation * position^index power, 7 of them since u can't have only one mis aligned at solved ig
  def orientation_id(state)
    state[0..6].each_with_index.sum { |x, i| (x % 3) * (3**(6 - i)) }
  end

  # the pattern databae needs perfect hashing with no collisions, for permutations a solution exsists known as an objects
  #  leher code
  def encode(state)
    index = lehmer(state.size, state)
    ori = orientation_id(state)
    index * 2187 + ori
  end

  def save(path)
    File.open(path, 'wb') { |f| Marshal.dump(@table, f) }
  end

  def load(path)
    File.open(path, 'rb') { |f| @table = Marshal.load(f) }
  end
end
