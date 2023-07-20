enum NewsState {
  loading,
  loaded,
  error,
}

class NewsError {
  final String message;

  NewsError(this.message);
}
