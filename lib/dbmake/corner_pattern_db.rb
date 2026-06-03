require_relative '../cubeRep/cube'
require_relative '../dataStruct/queue'
require_relative '../cubeRep/moves'
require_relative '../dataStruct/tree_node'
class CornerPatternDb
  include Moves
  def initialize
    @moves = make_moves
    @solved_arr = Cube.new.cube
    @table = {}
  end

  def make_moves
    base_moves = %w[R U D F B L]
    moves = []
    base_moves.each do |x|
      moves << x
      moves << "#{x}'"
      moves << "#{x}2"
    end
    moves
  end

  def makeDB
    queue = Queue.new
    node = TreeNode.new(@solved_arr.dup, '')
    until queue.empty?
      
    end
  end

  def addMoves(queue, state)
    @moves.each do |x|
      newstate = parse_moves(state, x)
      if @table.value?
        next
      else 
        @table[]
    end
  end
end
