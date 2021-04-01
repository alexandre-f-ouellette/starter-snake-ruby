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

  start_x = request.dig(:you, :head, :x)
  start_y = request.dig(:you, :head, :y)

  h_sorted_targets =
    request
    .dig(:board, :food)
    .sort do |a, b|
      start_node = Node.new(start_x, start_y)

      a_node_h_dist = start_node.distance(Node.new(a[:x], a[:y]))
      b_node_h_dist = start_node.distance(Node.new(b[:x], b[:y]))

      a_node_h_dist <=> b_node_h_dist
    end

  i = 0

  path =
    while i < h_sorted_targets.size
      target = h_sorted_targets[i]

      graph = Graph.new(
        width: request.dig(:board, :width),
        height: request.dig(:board, :height),
        start_x: start_x,
        start_y: start_y,
        obstacles: obstacles
      )

      graph.set_end(target[:x], target[:y])

      path = ASTAR.new(graph.start, graph.end).search

      i += 1

      break path if path.present?
    end

  next_node = path&.first

  if next_node.x > start_x
    'right'
  elsif next_node.x < start_x
    'left'
  elsif next_node.y > start_y
    'up'
  elsif next_node.y < start_y
    'down'
  else
    # TODO: replace this with navigating to biggest open space
    possible_moves.sample
  end
end
