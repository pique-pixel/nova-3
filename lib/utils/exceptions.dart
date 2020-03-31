void require(bool invariant, Exception Function() exceptionFactory) {
  if (!invariant) {
    throw exceptionFactory();
  }
}
