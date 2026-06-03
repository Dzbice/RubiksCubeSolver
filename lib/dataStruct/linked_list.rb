require_relative 'list_node'
class LinkedList
  attr_accessor :head, :tail, :length

  def initialize
    @head = nil
    @tail = nil
    @length = 0
  end

  def append(node)
    if @length.zero?
      @head = node
    else
      @tail.after = node
    end
    @tail = node
    @length += 1
  end

  def remove_head
    if @head == @tail
      @head = nil
      @tail = nil
      return
    end
    @head = @head.after
    @length -= 1
  end

  def remove_tail
    if @head == @tail
      @head = nil
      @tail = nil
    else
      node = @head
      (length - 2).times { node = node.after }
      @tail = node
      node.after = nil
    end
    @length -= 1
  end

  def empty?
    return true if @length <= 0

    false
  end
end
