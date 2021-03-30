# A 2D array of Node instances with relationships between Node
# instances built in. Obstacles & boundaries will have a nil value.
class Graph
  attr_reader :start, :end, :graph

  def initialize(width:, height:, start_x:, start_y:, obstacles: [])
    @width = width
    @height = height
    @obstacles = obstacles

    @graph = width.times.collect { Array.new(height) { nil } }

    build_nodes
    create_relationships

    @start = @graph[start_x][start_y]
  end

  def set_end(x, y)
    node = @graph[x][y]

    return ArgumentError, "Provided credentials do not refer to a Node" if node.nil?

    @end = node
  end

private

  def build_nodes
    @graph.each_with_index do |columns, x_index|
      columns.each_with_index do |y, y_index|
        next if @obstacles.any? { |coords| coords[:x] == x_index && coords[:y] == y_index }

        @graph[x_index][y_index] = Node.new(x_index, y_index)
      end
    end
  end

  def create_relationships
    @graph.each_with_index do |columns, x_index|
      columns.each_with_index do |y, y_index|
        next if y.nil?

        adjacent_coords = [
          [x_index + 1, y_index],
          [x_index - 1, y_index],
          [x_index, y_index + 1],
          [x_index, y_index - 1]
        ]

        adjacent_coords.each do |adj_x, adj_y|
          next unless inside?(adj_x, adj_y)

          y.insert(@graph[adj_x][adj_y]) unless @graph[adj_x][adj_y].nil?
        end
      end
    end
  end

  def inside?(x, y)
    ((0...@width).include?(x) && (0...@height).include?(y))
  end
end
