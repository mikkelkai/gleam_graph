import gleam_graph
import gleam_graph.{Graph}
import gleam/list
import gleam/map
import gleam/map.{Map}
import gleam/set
import gleam/bool
import gleam/set.{Set}

pub fn depth_first_search(
  g: Graph(vt, et),
  source: vt,
) -> Result(Map(vt, vt), Nil) {
  try res = dfs(g, set.new(), source)
  Ok(res.1)
}

fn dfs(
  g: Graph(vt, et),
  visited: Set(vt),
  current: vt,
) -> Result(#(Set(vt), Map(vt, vt)), Nil) {
  let visited = set.insert(visited, current)

  try reachable = gleam_graph.reachable_nodes(g, current)
  let frontier =
    list.filter(
      reachable,
      fn(node) { bool.negate(set.contains(visited, node)) },
    )

  frontier
  |> list.fold(
    from: Ok(#(visited, map.new())),
    with: fn(acc, el) {
      try #(visited, parents) = acc
      try #(visited, new_parents) = dfs(g, visited, el)
      let parents = map.merge(parents, new_parents)
      let parents =
        map.merge(
          parents,
          map.new()
          |> map.insert(el, current),
        )
      Ok(#(visited, parents))
    },
  )
}
