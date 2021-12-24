//// This module implements a heap using a leftist tree. Implementation is inspired by http://typeocaml.com/2015/03/12/heap-leftist-tree/.

type Value(a) =
  #(a, Float)

pub type Heap(a) {
  Node(value: Value(a), rank: Int, left: Heap(a), right: Heap(a))
  Leaf
}

pub fn new() -> Heap(a) {
  Leaf
}

fn singleton(a: Value(a)) -> Heap(a) {
  Node(a, 1, Leaf, Leaf)
}

pub fn insert(heap: Heap(a), a: Value(a)) -> Heap(a) {
  merge(heap, singleton(a))
}

pub fn pop(heap: Heap(a)) -> Result(#(a, Heap(a)), Nil) {
  case heap {
    Leaf -> Error(Nil)
    Node(x, _, l, r) -> Ok(#(x.0, merge(l, r)))
  }
}

fn rank(heap: Heap(a)) -> Int {
  case heap {
    Leaf -> 0
    Node(_, r, _, _) -> r
  }
}

pub fn merge(heap1: Heap(a), heap2: Heap(a)) -> Heap(a) {
  case #(heap1, heap2) {
    #(Leaf, t) | #(t, Leaf) -> t
    #(Node(v1, _, left, right), Node(v2, _, _, _)) ->
      case v1.1 >. v2.1 {
        True -> merge(heap2, heap1)
        False -> {
          let merged = merge(right, heap2)
          let rank_left = rank(left)
          let rank_right = rank(merged)
          case rank_left >= rank_right {
            True -> Node(v1, rank_right + 1, left, merged)
            False -> Node(v1, rank_left + 1, merged, left)
          }
        }
      }
  }
}
