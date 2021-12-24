import gleeunit/should
import gleam/erlang.{format}
import data_structures/heap

pub fn heap_test() {
  let h =
    heap.new()
    |> heap.insert(#(1, 5.))
    |> heap.insert(#(2, 1.))
    |> heap.insert(#(3, 6.))
    |> heap.insert(#(4, 3.))
    |> heap.insert(#(5, 2.))
    |> heap.insert(#(6, 4.))

  assert Ok(#(el, h)) = heap.pop(h)
  should.equal(el, 2)

  assert Ok(#(el, h)) = heap.pop(h)
  should.equal(el, 5)

  assert Ok(#(el, h)) = heap.pop(h)
  should.equal(el, 4)

  assert Ok(#(el, h)) = heap.pop(h)
  should.equal(el, 6)

  assert Ok(#(el, h)) = heap.pop(h)
  should.equal(el, 1)

  assert Ok(#(el, h)) = heap.pop(h)
  should.equal(el, 3)

  should.be_error(heap.pop(h))
}
