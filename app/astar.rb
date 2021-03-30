## Original logic taken from: https://github.com/MatteoRagni/ruby-astar/blob/master/astar.rb


# The actual A* Algorithm is encapsulated in a class
# It has some methods that are used internally, but the main
# method is search, that actually explores the graph
class ASTAR

  def initialize(start, stop)
    [start, stop].each do |e|
      raise ArgumentError, "Required a Node as input. Received a #{e.class} for #{e.index}" unless e.is_a? Node
    end


    # Let's register a starting node and a ending node
    @start = start
    @stop  = stop

    # There will be two sets at the center of the algorithm.
    # The first is the openset, that is the set that contains
    # all the nodes that we have not explored yet.
    # It is initialized with only the starting node.
    @openset = [@start]
    # The closed set is the second set that contains all
    # the nodes thar already been explored and are in our
    # path or are failing strategy
    @closedset = []

    # Let's initialize the starting point
    # Obviously it has distance from start that is zero
    @start.h_dist_start = 0
    # and we evaluate the distance from the ending point
    @start.h_dist_end = @start.distance(@stop)
  end

  def search
    # The search continues until there are nodes in the openset
    # If there are no nodes, the path will be an empty list.
    while @openset.size > 0
      # The next node is the one that has the minimum distance
      # from the origin and the minimum distance from the exit.
      # Thus it should have the minimum value of f.
      x = openset_min_f()

      # If the next node selected is the stop node we are arrived.
      if x == @stop
        # And we can return the path by reconstructing it
        # recursively backward.
        return reconstruct_path(x)
      end

      # We are now inspecting the node x. We have to remove it
      # from the openset, and to add it to the closedset.
      @openset -= [x]
      @closedset += [x]

      # Let's test all the nodes that are near to the current one
      x.next_nodes.each do |y|

        # Obviously, we do not analyze the current node if it
        # is already in the closed set
        next if @closedset.include?(y)

        # Let's make an evaluation of the distance from the
        # starting point. We can evaluate the distance in a way
        # that we actually get a correct valu of distance.
        # It must be saved in a temporary variable, because
        # it must be checked against the h_dist_start inside the node
        # (if it was already evaluated)
        new_h_dist_start = x.h_dist_start + x.distance(y)

        # There are three condition to be taken into account
        #  1. y is not in the openset. This is always an improvement
        #  2. y is in the openset, but the new h_dist_start is lower
        #     so we have found a better strategy to reach y
        #  3. y has already a better h_dist_start, or in any case
        #     this strategy is not an improvement

        if !@openset.include?(y)
          @openset += [y]
          improving = true
        elsif new_h_dist_start < y.h_dist_start
          improving = true
        else
          improving = false
        end

        # We had an improvement
        if improving
          y.previous_node = x
          y.h_dist_start = new_h_dist_start
          y.h_dist_end = y.distance(@stop)
        end
      end
    end

    # If we never encountered a return before means that we
    # have finished the node in the openset and we never
    # reached the @stop point.
    # We are returning an empty path.
    return []
  end

  private

  # Searches the node with the minimum h_dist_total in the openset
  def openset_min_f
    ret = @openset[0]
    for i in 1...@openset.size
      ret = @openset[i] if ret.h_dist_total > @openset[i].h_dist_total
    end
    return ret
  end

  ##
  # It reconstructs the path by using a recursive function
  # that runs from the last node till the beginning.
  # It is stopped when the analyzed node has previous_node == nil
  def reconstruct_path(curr)
    return ( curr.previous_node ? reconstruct_path(curr.previous_node) + [curr] : [] )
  end # reconstruct_path

end # ASTAR
