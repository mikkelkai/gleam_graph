//// This module provides a simple graph structure,
//// which supports directed and undirected edges with optional weighting and the possibility of adding custom data.
//// 
//// Nodes can be any type as long as when they are referenced again, the vertex equals the one in the graph.
//// However it is recommended to create a map where the keys are used as nodes in the graph instead of using the node directly.
//// This allows changing the nodes without changing the graph, as well as often being faster, since simpler keys like numbers are faster to compare than complex types.

import gleam/int
import gleam/list
import gleam/map
import gleam/map.{Map}
import gleam/option
import gleam/option.{None, Option, Some}

// Types
/// Type that represents edges in the graph.
pub opaque type Edge(vt, et) {
  DirectedEdge(from: vt, to: vt, weight: Option(Float), data: Option(et))
  UndirectedEdge(between: #(vt, vt), weight: Option(Float), data: Option(et))
}

/// Type that represents the graph.
pub opaque type Graph(vt, et) {
  Graph(graph: Map(vt, List(Edge(vt, et))), order: Int, size: Int)
}

// Construction
/// Function that creates a new empty graph.
pub fn create() -> Graph(vt, et) {
  Graph(graph: map.new(), order: 0, size: 0)
}

/// Function that adds a new node to a graph.
pub fn add_node(g: Graph(vt, et), node: vt) -> Graph(vt, et) {
  Graph(..g, graph: map.insert(g.graph, node, []), order: g.order + 1)
}

fn add_element(n: Option(List(e)), el: e) -> List(e) {
  case n {
    Some(lst) -> [el, ..lst]
    None -> [el]
  }
}

fn raw_add_edge(
  g: Graph(vt, et),
  from: vt,
  to: vt,
  weight: Option(Float),
  data: Option(et),
) -> Graph(vt, et) {
  let seen_from = map.has_key(g.graph, from)
  let seen_to = map.has_key(g.graph, to)
  let g = case seen_to {
    True -> g
    False -> add_node(g, to)
  }
  let order_increase = case seen_from {
    True -> 0
    False -> 1
  }
  let new_graph =
    map.update(
      g.graph,
      from,
      add_element(_, DirectedEdge(from, to, weight, data)),
    )
  Graph(
    ..g,
    graph: new_graph,
    size: g.size + 1,
    order: g.order + order_increase,
  )
}

/// Function that adds a directed edge with a weight to the graph.
///
/// When referencing a vertex which does not exist in the graph, it will automatically be created.
pub fn add_weighted_edge(
  g: Graph(vt, et),
  from: vt,
  to: vt,
  weight: Float,
  data: Option(et),
) -> Graph(vt, et) {
  raw_add_edge(g, from, to, Some(weight), data)
}

/// Function that adds a directed edge to the graph.
///
/// When referencing a vertex which does not exist in the graph, it will automatically be created.
pub fn add_edge(g: Graph(vt, et), from: vt, to: vt, data: Option(et)) {
  raw_add_edge(g, from, to, None, data)
}

fn raw_add_undirected_edge(
  g: Graph(vt, et),
  from: vt,
  to: vt,
  weight: Option(Float),
  data: Option(et),
) -> Graph(vt, et) {
  let seen_from = map.has_key(g.graph, from)
  let seen_to = map.has_key(g.graph, to)
  let g = case seen_to {
    False -> add_node(g, to)
    True -> g
  }
  let order_increase = case seen_from {
    True -> 0
    False -> 1
  }
  let edge = UndirectedEdge(#(from, to), weight, data)
  let new_graph =
    map.update(g.graph, from, add_element(_, edge))
    |> map.update(to, add_element(_, edge))
  Graph(
    ..g,
    graph: new_graph,
    size: g.size + 1,
    order: g.order + order_increase,
  )
}

/// Function that adds an undirected edge with a weight to the graph.
///
/// When referencing a vertex which does not exist in the graph, it will automatically be created.
pub fn add_weighted_undirected_edge(
  g: Graph(vt, et),
  from: vt,
  to: vt,
  weight: Float,
  data: Option(et),
) {
  raw_add_undirected_edge(g, from, to, Some(weight), data)
}

/// Function that adds an undirected edge to the graph.
///
/// When referencing a vertex which does not exist in the graph, it will automatically be created.
pub fn add_undirected_edge(g: Graph(vt, et), from: vt, to: vt, data: Option(et)) {
  raw_add_undirected_edge(g, from, to, None, data)
}

// Operations
/// Function that returns the amount of nodes in the graph.
pub fn order(g: Graph(vt, et)) -> Int {
  g.order
}

/// Function that returns the amount of edges in the graph.
pub fn size(g: Graph(vt, et)) -> Int {
  g.size
}

/// Function that returns the number of edges going from a given node.
pub fn out_degree(g: Graph(vt, et), node: vt) -> Result(Int, Nil) {
  try edges = map.get(g.graph, node)
  Ok(list.length(edges))
}

/// Function that returns a tuple describing what is reachable for a node.
pub fn reachable(
  g: Graph(vt, et),
  node: vt,
) -> Result(List(#(vt, Option(Float), Option(et))), Nil) {
  try edges = map.get(g.graph, node)
  Ok(list.map(
    edges,
    fn(edge) {
      case edge {
        DirectedEdge(_, to, weight, data) -> #(to, weight, data)
        UndirectedEdge(between, weight, data) ->
          case between.0 == node {
            True -> #(between.1, weight, data)
            False -> #(between.0, weight, data)
          }
      }
    },
  ))
}

/// Function that returns the nodes which can be used to reached from a given node.
pub fn reachable_nodes(g: Graph(vt, et), node: vt) -> Result(List(vt), Nil) {
  try r = reachable(g, node)
  Ok(list.map(r, fn(edge: #(vt, Option(Float), Option(et))) { edge.0 }))
}
