import gleeunit
import gleam_graph
import gleam/io
import gleam/option.{None, Some}
import gleam/erlang.{format}

pub fn main() {
  gleeunit.main()
}

pub fn new_test() {
  let graph = gleam_graph.new()

  assert 0 = gleam_graph.order(graph)
  assert 0 = gleam_graph.size(graph)

  let _graph =
    graph
    |> gleam_graph.add_node(10)
    |> gleam_graph.add_node(1)
    |> gleam_graph.add_edge(1, 10, None)
    |> gleam_graph.add_edge(2, 9, None)
    |> gleam_graph.add_weighted_edge(7, 9, 10., None)
    |> gleam_graph.add_undirected_edge(1, 2, None)
    |> gleam_graph.add_weighted_undirected_edge(5, 7, 0., None)
}

pub fn order_test() {
  let graph =
    gleam_graph.new()
    |> gleam_graph.add_node(10)
    |> gleam_graph.add_node(1)
    |> gleam_graph.add_edge(1, 10, None)
    |> gleam_graph.add_edge(2, 9, None)
    |> gleam_graph.add_weighted_edge(7, 9, 10., None)
    |> gleam_graph.add_undirected_edge(1, 2, None)
    |> gleam_graph.add_weighted_undirected_edge(5, 7, 0., None)

  io.println(format(gleam_graph.order(graph)))

  assert 6 = gleam_graph.order(graph)
}

pub fn size_test() {
  let graph =
    gleam_graph.new()
    |> gleam_graph.add_node(10)
    |> gleam_graph.add_node(1)
    |> gleam_graph.add_edge(1, 10, None)
    |> gleam_graph.add_edge(2, 9, None)
    |> gleam_graph.add_weighted_edge(7, 9, 10., None)
    |> gleam_graph.add_undirected_edge(1, 2, None)
    |> gleam_graph.add_weighted_undirected_edge(5, 7, 0., None)

  assert 5 = gleam_graph.size(graph)
}

pub fn out_degree_test() {
  let graph =
    gleam_graph.new()
    |> gleam_graph.add_node(10)
    |> gleam_graph.add_node(1)
    |> gleam_graph.add_edge(1, 10, None)
    |> gleam_graph.add_edge(2, 9, None)
    |> gleam_graph.add_weighted_edge(7, 9, 10., None)
    |> gleam_graph.add_undirected_edge(1, 2, None)
    |> gleam_graph.add_weighted_undirected_edge(5, 7, 0., None)

  assert Ok(2) = gleam_graph.out_degree(graph, 1)
  assert Ok(2) = gleam_graph.out_degree(graph, 2)
  assert Ok(1) = gleam_graph.out_degree(graph, 5)
  assert Ok(2) = gleam_graph.out_degree(graph, 7)
  assert Ok(0) = gleam_graph.out_degree(graph, 9)
  assert Ok(0) = gleam_graph.out_degree(graph, 10)
}

pub fn reachable_edges_test() {
  let graph =
    gleam_graph.new()
    |> gleam_graph.add_node(10)
    |> gleam_graph.add_node(1)
    |> gleam_graph.add_edge(1, 10, None)
    |> gleam_graph.add_edge(2, 9, None)
    |> gleam_graph.add_weighted_edge(7, 9, 10., None)
    |> gleam_graph.add_undirected_edge(1, 2, None)
    |> gleam_graph.add_weighted_undirected_edge(5, 7, 0., None)

  // TODO: Make ordering irrelevant
  assert Ok([#(2, None, None), #(10, None, None)]) =
    gleam_graph.reachable(graph, 1)
  assert Ok([#(1, None, None), #(9, None, None)]) =
    gleam_graph.reachable(graph, 2)
  assert Ok([#(7, Some(0.), None)]) = gleam_graph.reachable(graph, 5)
  assert Ok([#(5, Some(0.), None), #(9, Some(10.), None)]) =
    gleam_graph.reachable(graph, 7)
  assert Ok([]) = gleam_graph.reachable(graph, 9)
  assert Ok([]) = gleam_graph.reachable(graph, 10)
}

pub fn reachable_nodes_test() {
  let graph =
    gleam_graph.new()
    |> gleam_graph.add_node(10)
    |> gleam_graph.add_node(1)
    |> gleam_graph.add_edge(1, 10, None)
    |> gleam_graph.add_edge(2, 9, None)
    |> gleam_graph.add_weighted_edge(7, 9, 10., None)
    |> gleam_graph.add_undirected_edge(1, 2, None)
    |> gleam_graph.add_weighted_undirected_edge(5, 7, 0., None)

  let x = gleam_graph.reachable_nodes(graph, 1)

  io.println(format(x))

  // TODO: Make ordering irrelevant
  assert Ok([2, 10]) = gleam_graph.reachable_nodes(graph, 1)
  assert Ok([1, 9]) = gleam_graph.reachable_nodes(graph, 2)
  assert Ok([7]) = gleam_graph.reachable_nodes(graph, 5)
  assert Ok([5, 9]) = gleam_graph.reachable_nodes(graph, 7)
  assert Ok([]) = gleam_graph.reachable_nodes(graph, 9)
  assert Ok([]) = gleam_graph.reachable_nodes(graph, 10)
}
