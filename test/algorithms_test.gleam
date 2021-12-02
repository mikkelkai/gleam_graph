import gleam/io
import gleam/map
import gleam/erlang.{format}
import gleam_graph
import gleam_graph/algorithms
import gleam/option.{None, Some}

pub fn depth_first_search_test() {
  let graph =
    gleam_graph.new()
    |> gleam_graph.add_undirected_edge(1, 2, None)
    |> gleam_graph.add_undirected_edge(2, 4, None)
    |> gleam_graph.add_undirected_edge(3, 4, None)
    |> gleam_graph.add_undirected_edge(1, 3, None)

  // TODO: Create ordering idependent tests
  assert Ok(found) = algorithms.depth_first_search(graph, 1)

  let expected =
    map.new()
    |> map.insert(2, 1)
    |> map.insert(3, 4)
    |> map.insert(4, 2)

  let same = found == expected
  io.println(format(found))

  assert True = same
}

pub fn breadth_first_search_test() {
  let graph =
    gleam_graph.new()
    |> gleam_graph.add_undirected_edge(1, 2, None)
    |> gleam_graph.add_undirected_edge(2, 4, None)
    |> gleam_graph.add_undirected_edge(3, 4, None)
    |> gleam_graph.add_undirected_edge(1, 3, None)

  // TODO: Create ordering idependent tests
  assert Ok(found) = algorithms.breadth_first_search(graph, 1)

  let expected =
    map.new()
    |> map.insert(2, 1)
    |> map.insert(3, 1)
    |> map.insert(4, 3)

  let same = found == expected
  io.println(format(found))

  assert True = same
}

pub fn dijkstra_test() {
  let graph =
    gleam_graph.new()
    |> gleam_graph.add_weighted_edge(1, 2, 10., None)
    |> gleam_graph.add_weighted_edge(2, 3, 1., None)
    |> gleam_graph.add_weighted_edge(1, 4, 1., None)
    |> gleam_graph.add_weighted_edge(4, 5, 1., None)
    |> gleam_graph.add_weighted_edge(5, 6, 1., None)
    |> gleam_graph.add_weighted_edge(6, 7, 9., None)
    |> gleam_graph.add_edge(3, 8, None)
    |> gleam_graph.add_edge(7, 8, None)

  // TODO: Create ordering idependent tests
  assert Ok(found) = algorithms.dijkstra(graph, 1)

  let expected =
    map.new()
    |> map.insert(2, 1)
    |> map.insert(3, 2)
    |> map.insert(4, 1)
    |> map.insert(5, 4)
    |> map.insert(6, 5)
    |> map.insert(7, 6)
    |> map.insert(8, 3)

  let same = found == expected
  io.println(format(found))

  assert True = same
}
