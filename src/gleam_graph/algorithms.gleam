//// This module implements various common graph algorithms.

import gleam_graph
import gleam_graph.{Graph}
import gleam/map
import gleam/map.{Map}
import gleam/set
import gleam/set.{Set}
import gleam/queue
import gleam/queue.{Queue}
import gleam/list
import gleam/result
import gleam/bool
import gleam/float
import gleam/option.{None, Option, Some}
import gleam/io
import gleam/erlang.{format}

/// Function that computes a depth first search through the graph from a given node.
pub fn depth_first_search(
  g: Graph(vt, et),
  source: vt,
) -> Result(Map(vt, vt), Nil) {
  result.map(dfs(g, set.new(), [#(source, source)]), map.delete(_, source))
}

fn dfs(
  g: Graph(vt, et),
  visited: Set(vt),
  node_queue: List(#(vt, vt)),
) -> Result(Map(vt, vt), Nil) {
  case node_queue {
    [] -> Ok(map.new())
    [#(current, parent), ..node_queue] ->
      case set.contains(visited, current) {
        True -> dfs(g, visited, node_queue)
        False -> {
          try reachable = gleam_graph.reachable_nodes(g, current)
          let new_queue =
            reachable
            |> list.fold(
              from: node_queue,
              with: fn(acc, el) { [#(el, current), ..acc] },
            )
          let visited =
            visited
            |> set.insert(current)
          result.map(
            dfs(g, visited, new_queue),
            fn(parents) { map.insert(parents, current, parent) },
          )
        }
      }
  }
}

/// Function that computes a breadth first search through the graph from a given node.
pub fn breadth_first_search(
  g: Graph(vt, et),
  source: vt,
) -> Result(Map(vt, vt), Nil) {
  result.map(
    bfs(
      g,
      set.new(),
      [#(source, source)]
      |> queue.from_list,
    ),
    map.delete(_, source),
  )
}

fn bfs(
  g: Graph(vt, et),
  visited: Set(vt),
  node_queue: Queue(#(vt, vt)),
) -> Result(Map(vt, vt), Nil) {
  case queue.is_empty(node_queue) {
    True -> Ok(map.new())
    False -> {
      assert Ok(#(#(current, parent), node_queue)) = queue.pop_front(node_queue)
      case set.contains(visited, current) {
        True -> bfs(g, visited, node_queue)
        False -> {
          try reachable = gleam_graph.reachable_nodes(g, current)
          let new_queue =
            reachable
            |> list.fold(
              from: node_queue,
              with: fn(acc, el) { queue.push_back(acc, #(el, current)) },
            )
          let visited =
            visited
            |> set.insert(current)
          result.map(
            bfs(g, visited, new_queue),
            fn(parents) { map.insert(parents, current, parent) },
          )
        }
      }
    }
  }
}

/// Function that computes a breadth first search through the graph from a given node.
pub fn dijkstra(g: Graph(vt, et), source: vt) -> Result(Map(vt, vt), Nil) {
  result.map(
    dijkstra_(
      g,
      set.new(),
      map.new()
      |> map.insert(source, 0.),
      [#(source, source, 0.)],
    ),
    map.delete(_, source),
  )
}

// TODO: Implement using priority queue
fn dijkstra_(
  g: Graph(vt, et),
  visited: Set(vt),
  dists: Map(vt, Float),
  node_queue: List(#(vt, vt, Float)),
) -> Result(Map(vt, vt), Nil) {
  let node_queue =
    node_queue
    |> list.sort(fn(a: #(vt, vt, Float), b: #(vt, vt, Float)) {
      assert Ok(a_dist) = map.get(dists, a.1)
      assert Ok(b_dist) = map.get(dists, b.1)
      let a = a_dist +. a.2
      let b = b_dist +. b.2
      float.compare(a, b)
    })
  case node_queue {
    [] -> Ok(map.new())
    [#(current, parent, weight), ..node_queue] ->
      case set.contains(visited, current) {
        True -> dijkstra_(g, visited, dists, node_queue)
        False -> {
          try reachable = gleam_graph.reachable(g, current)
          let new_queue =
            reachable
            |> list.fold(
              from: node_queue,
              with: fn(acc, el: #(vt, Option(Float), Option(et))) {
                [
                  #(
                    el.0,
                    current,
                    case el.1 {
                      None -> 0.
                      Some(n) -> n
                    },
                  ),
                  ..acc
                ]
              },
            )
          try parent_dist = map.get(dists, parent)
          let visited =
            visited
            |> set.insert(current)
          let dists =
            dists
            |> map.insert(current, parent_dist +. weight)
          result.map(
            dijkstra_(g, visited, dists, new_queue),
            fn(parents) { map.insert(parents, current, parent) },
          )
        }
      }
  }
}
