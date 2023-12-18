struct _MatchResult<S: MatchingCollectionSearcher> {
  let match: S.Searched.SubSequence
  let result: S.Match
  var range: Range<S.Searched.Index> {
    match.startIndex..<match.endIndex
  }
}
struct _BackwardMatchResult<S: BackwardMatchingCollectionSearcher> {
  let match: S.BackwardSearched.SubSequence
  let result: S.Match
  var range: Range<S.BackwardSearched.Index> {
    match.startIndex..<match.endIndex
  }
}
