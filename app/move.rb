# This function is called on every turn of a game. It's how your Battlesnake decides where to move.
# Valid moves are "up", "down", "left", or "right".
# TODO: Use the information in board to decide your next move.
def move(request)
  possible_moves = %w[up down left right]
  my_snake_id = request.dig(:you, :id)

  obstacles =
    request.dig(:board, :snakes).each_with_object([]) do |snake, res|
      next if snake[:id] == my_snake_id && request[:turn].zero?

      # don't add my own head as an obstacle
      snake[:body].shift if snake[:id] == my_snake_id

      res << snake[:body]
    end.flatten.uniq

  graph = Graph.new(
    width: request.dig(:board, :width),
    height: request.dig(:board, :height),
    start_x: request.dig(:you, :head, :x),
    start_y: request.dig(:you, :head, :y),
    obstacles: obstacles
  )

  h_sorted_foods =
    request
    .dig(:board, :food)
    .sort do |a, b|
      a_node_h_dist = graph.start.distance(Node.new(a[:x], a[:x]))
      b_node_h_dist = graph.start.distance(Node.new(b[:x], b[:x]))

      a_node_h_dist <=> b_node_h_dist
    end

  food = h_sorted_foods.first

  graph.set_end(food[:x], food[:y])

  path = ASTAR.new(graph.start, graph.end).search

  next_node = path&.first

  if next_node.x > graph.start.x
    'right'
  elsif next_node.x < graph.start.x
    'left'
  elsif next_node.y > graph.start.y
    'up'
  elsif next_node.y < graph.start.y
    'down'
  else
    possible_moves.sample
  end
end
