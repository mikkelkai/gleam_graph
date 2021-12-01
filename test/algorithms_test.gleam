import gleam/io
import gleam/map
import gleam/erlang.{format}
import gleam_graph
import gleam_graph/algorithms
import gleam/option.{None, Some}

pub fn depth_first_search_test() {
  let graph =
    gleam_graph.new()
    |> gleam_graph.add_node(10)
    |> gleam_graph.add_node(1)
    |> gleam_graph.add_edge(1, 10, None)
    |> gleam_graph.add_edge(2, 9, None)
    |> gleam_graph.add_edge(10, 5, None)
    |> gleam_graph.add_weighted_edge(7, 9, 10., None)
    |> gleam_graph.add_undirected_edge(1, 2, None)
    |> gleam_graph.add_weighted_undirected_edge(5, 7, 0., None)

  assert Ok(found) = algorithms.depth_first_search(graph, 1)

  let expected =
    map.new()
    |> map.insert(2, 1)
    |> map.insert(9, 2)
    |> map.insert(10, 1)
    |> map.insert(5, 10)
    |> map.insert(7, 5)

  let same = found == expected

  assert True = same

  assert Ok(found) = algorithms.depth_first_search(graph, 2)

  let expected =
    map.new()
    |> map.insert(9, 2)
    |> map.insert(1, 2)
    |> map.insert(10, 1)
    |> map.insert(5, 10)
    |> map.insert(7, 5)

  let same = found == expected

  assert True = same

  assert Ok(found) = algorithms.depth_first_search(graph, 5)

  let expected =
    map.new()
    |> map.insert(9, 7)
    |> map.insert(7, 5)

  let same = found == expected

  assert True = same

  assert Ok(found) = algorithms.depth_first_search(graph, 7)

  let expected =
    map.new()
    |> map.insert(9, 7)
    |> map.insert(5, 7)

  let same = found == expected

  assert True = same

  assert Ok(found) = algorithms.depth_first_search(graph, 9)

  let expected = map.new()

  let same = found == expected

  assert True = same

  assert Ok(found) = algorithms.depth_first_search(graph, 10)

  let expected =
    map.new()
    |> map.insert(5, 10)
    |> map.insert(7, 5)
    |> map.insert(9, 7)

  let same = found == expected

  assert True = same
}
