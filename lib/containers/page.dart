class Page<T> {
  final List<T> data;
  final int nextPage;

  bool get isLastPage => nextPage == null;

  Page({
    this.data,
    this.nextPage = 2,
  });
}
