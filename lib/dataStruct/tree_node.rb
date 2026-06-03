class TreeNode
  attr_accessor :state, :sequence, :depth

  def initialize(state, sequence, depth)
    @state = state
    @sequence = sequence
    @depth = depth
    @after = nil
  end
end
