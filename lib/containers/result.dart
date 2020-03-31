class Result<L, R> {
  final L _ok;
  final R _error;

  Result.ok(this._ok) : _error = null;

  Result.error(this._error) : _ok = null;

  match(void Function(L value) ok, void Function(R value) error) {
    if (this._ok != null) {
      ok(this._ok);
    } else if (this._error != null) {
      error(this._error);
    } else {
      throw new AssertionError('$Result should have at least one value ok or error');
    }
  }

  okApply(void Function(L value) ok) {
    if (this._ok != null) {
      ok(this._ok);
    }
  }

  errorApply(void Function(R value) error) {
    if (this._error != null) {
      error(this._error);
    }
  }

  Result<T, R> map<T>(T Function(L) mapper) {
    if (this._ok != null) {
      return Result.ok(mapper(this._ok));
    } else if (this._error != null) {
      return Result.error(this._error);
    } else {
      throw new AssertionError('$Result should have at least one value ok or error');
    }
  }

  Result<L, T> mapError<T>(T Function(R) mapper) {
    if (this._ok != null) {
      return Result.ok(this._ok);
    } else if (this._error != null) {
      return Result.error(mapper(this._error));
    } else {
      throw new AssertionError('$Result should have at least one value ok or error');
    }
  }

  L unwrap() {
    if (this._ok != null) {
      return this._ok;
    } else {
      throw this._error;
    }
  }
}
