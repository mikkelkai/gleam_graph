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
import data_structures/heap
import data_structures/heap.{Heap}
import gleam/erlang.{format}

/// Computes a depth first search through the graph from a given node.
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

/// Computes a breadth first search through the graph from a given node.
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

/// Computes shortest distance through the graph from a given node.
pub fn dijkstra(g: Graph(vt, et), source: vt) -> Result(Map(vt, vt), Nil) {
  result.map(
    dijkstra_(
      g,
      set.new(),
      heap.new()
      |> heap.insert(#(#(source, source, 0.), 0.)),
    ),
    map.delete(_, source),
  )
}

fn dijkstra_(
  g: Graph(vt, et),
  visited: Set(vt),
  node_queue: Heap(#(vt, vt, Float)),
) -> Result(Map(vt, vt), Nil) {
  case heap.pop(node_queue) {
    Error(_) -> Ok(map.new())
    Ok(#(#(current, parent, dist), node_queue)) ->
      case set.contains(visited, current) {
        True -> dijkstra_(g, visited, node_queue)
        False -> {
          try reachable = gleam_graph.reachable(g, current)
          let visited =
            visited
            |> set.insert(current)
          let new_queue =
            reachable
            |> list.fold(
              from: node_queue,
              with: fn(acc, el: #(vt, Option(Float), Option(et))) {
                let el_dist =
                  dist +. case el.1 {
                    None -> 0.
                    Some(n) -> n
                  }
                let context = #(el.0, current, el_dist)
                acc
                |> heap.insert(#(context, el_dist))
              },
            )
          result.map(
            dijkstra_(g, visited, new_queue),
            fn(parents) { map.insert(parents, current, parent) },
          )
        }
      }
  }
}
