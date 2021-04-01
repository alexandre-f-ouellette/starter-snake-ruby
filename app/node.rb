## Original logic taken from: https://github.com/MatteoRagni/ruby-astar/blob/master/node.rb

# The Node class contains everything that is necessary to describe
# a complete graph. The node has a description of the edge to the previous
# Node (@prev), and an Array of edges to the next Nodes (@near).
#
# The Node contains also
#  - @x, @y: indication of the position of the node
#  - @previous_node: the edge to previous position
#  - @next_nodes: the edges to next positions
#  - @h_dist_start: the heuristic distance to the start node
#  - @h_dist_end: the heuristic distance to the stop node
# The total heuristic distance is the sum of (@h_dist_start + @h_dist_end)
class Node
  attr_accessor :h_dist_start, :h_dist_end, :previous_node
  attr_reader :x, :y, :next_nodes

  ##
  # Initialize an empty new Node. The only informations it has
  # are the coordinates (x, y).
  def initialize(x, y)
    [x, y].each do |input|
      raise ArgumentError, "input must be a Numeric.\n Received a #{input.class}" unless input.is_a? Numeric
    end

    @x = x
    @y = y

    @h_dist_start = 0.0
    @h_dist_end = 0.0

    @previous_node = nil
    @next_nodes = []
  end

  ##
  # The total heuristic distance
  def h_dist_total
    h_dist_start + h_dist_end
  end

  def coords
    {
      x: @x,
      y: @y
    }
  end

  # Evaluates the distance of the current node with another node
  def distance(other_node)
    raise ArgumentError, "A Node must be given as input.\n Received a #{other_node.class}" unless other_node.is_a? Node

    ((@x - other_node.x)**2 + (@y - other_node.y)**2)**0.5
  end

  # Add a new edge to a Node in the edges list @next_nodes.
  def insert(node)
    raise ArgumentError, "A Node must be given as input.\n Received a #{node.class}" unless node.is_a? Node

    @next_nodes << node
  end
end
