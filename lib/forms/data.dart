abstract class FormValue<T> {
  final T data;

  FormValue(this.data);

  bool isEmpty();

  int length();
}

class StringFormValue implements FormValue<String> {
  final String data;

  const StringFormValue([this.data = '']);

  @override
  bool isEmpty() {
    return data.isEmpty;
  }

  @override
  String toString() => '$StringFormValue("$data")';

  @override
  int length() => data.length;
}