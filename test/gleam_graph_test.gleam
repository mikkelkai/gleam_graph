import gleam_graph
import gleam/io
import gleam/option.{None, Some}
import gleam/erlang.{format}

pub fn create_test() {
  assert graph =
    gleam_graph.create()
    |> gleam_graph.add_node(10)
    |> gleam_graph.add_node(1)
    |> gleam_graph.add_edge(1, 10, None)
    |> gleam_graph.add_edge(2, 9, None)
    |> gleam_graph.add_weighted_edge(7, 9, 10., None)
    |> gleam_graph.add_undirected_edge(1, 2, None)
    |> gleam_graph.add_weighted_undirected_edge(5, 7, 0., None)
}

pub fn order_test() {
  assert graph =
    gleam_graph.create()
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
  assert graph =
    gleam_graph.create()
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
  assert graph =
    gleam_graph.create()
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

pub fn reachable_nodes_test() {
  assert graph =
    gleam_graph.create()
    |> gleam_graph.add_node(10)
    |> gleam_graph.add_node(1)
    |> gleam_graph.add_edge(1, 10, None)
    |> gleam_graph.add_edge(2, 9, None)
    |> gleam_graph.add_weighted_edge(7, 9, 10., None)
    |> gleam_graph.add_undirected_edge(1, 2, None)
    |> gleam_graph.add_weighted_undirected_edge(5, 7, 0., None)

  let x = gleam_graph.reachable_nodes(graph, 1)

  io.println(format(x))

  assert Ok([2, 10]) = gleam_graph.reachable_nodes(graph, 1)
}
