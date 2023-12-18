extension String {
  @available(
    *, unavailable,
    message: "cannot subscript String with an Int, use a String.Index instead."
  )
  public subscript(i: Int) -> Character {
    Builtin.unreachable()
  }
  @available(
    *, unavailable,
    message: "cannot subscript String with an integer range, use a String.Index range instead."
  )
  public subscript<R: RangeExpression>(bounds: R) -> String where R.Bound == Int {
    Builtin.unreachable()
  }
}
