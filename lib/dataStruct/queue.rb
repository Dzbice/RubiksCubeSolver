require_relative 'linked_list'
require_relative 'list_node'
class Queue
  def initialize
    @list = LinkedList.new
  end

  def peek
    @list.head
  end

  def push(value)
    @list.append(ListNode.new(value))
  end

  def pop
    node = @list.head
    @list.remove_head
    node
  end

  def empty?
    @list.empty?
  end

  def size
    @list.length
  end
end
