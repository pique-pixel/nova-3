import 'package:optional/optional_internal.dart';

import '../exceptions.dart';

T getJsonValue<T>(Map<String, dynamic> json, String key) {
  if (!json.containsKey(key)) {
    throw SchemeConsistencyException('key "$key" hasn\'t found');
  } else if (json[key] is! T) {
    throw SchemeConsistencyException(
      'Wrong type by key "$key", expected: "$T" '
      'but has got: "${json[key].runtimeType}"',
    );
  } else {
    return json[key] as T;
  }
}

Optional<T> getJsonValueOrEmpty<T>(
  Map<String, dynamic> json,
  String key,
) {
  if (json.containsKey(key) && json[key] != null) {
    return Optional.of(getJsonValue(json, key));
  } else {
    return Optional.empty();
  }
}

Optional<T> transformJsonValueOrEmpty<T, R>(
  Map<String, dynamic> json,
  String key,
  T Function(R) transform,
) {
  if (json.containsKey(key) && json[key] != null) {
    return Optional.of(transform(getJsonValue(json, key)));
  } else {
    return Optional.empty();
  }
}

List<T> transformJsonListOfMap<T>(
  Map<String, dynamic> json,
  String key,
  T transform(Map<String, dynamic> json),
) {
  List<dynamic> list = getJsonValue(json, key);

  final mapper = (it) {
    try {
      return transform(it as Map<String, dynamic>);
    } on Exception catch (e) {
      throw SchemeConsistencyException(
        'Failed to transform value "$it";\ncause: $e',
      );
    }
  };

  return list.length == 0 ? [] : list.map(mapper).toList();
}

Optional<List<T>> transformJsonListOfMapOrEmpty<T>(
  Map<String, dynamic> json,
  String key,
  T transform(Map<String, dynamic> json),
) {
  if (json.containsKey(key) && json[key] != null) {
    List<dynamic> list = getJsonValue(json, key);

    final mapper = (it) {
      try {
        return transform(it as Map<String, dynamic>);
      } on Exception catch (e) {
        throw SchemeConsistencyException(
          'Failed to transform value "$it";\ncause: $e',
        );
      }
    };

    return Optional.of(list.length == 0 ? [] : list.map(mapper).toList());
  } else {
    return Optional.empty();
  }
}

List<T> transformJsonList<T>(
  List<dynamic> json,
  T transform(Map<String, dynamic> json),
) {
  final mapper = (it) {
    try {
      return transform(it as Map<String, dynamic>);
    } on Exception catch (e) {
      throw SchemeConsistencyException(
        'Failed to transform value "$it";\ncause: $e',
      );
    }
  };

  return json.length == 0 ? [] : json.map(mapper).toList();
}

List<T> getJsonList<T>(
  Map<String, dynamic> json,
  String key,
) {
  List<dynamic> list = getJsonValue(json, key);

  final mapper = (it) {
    if (it is T) {
      return it;
    } else {
      throw SchemeConsistencyException(
        'Wrong type by key "$key", expected: "List<$T>" '
        'but has got element in list of type: "${it.runtimeType}"',
      );
    }
  };

  return list.length == 0 ? <T>[] : list.map(mapper).toList();
}

Optional<List<T>> getJsonListOrEmpty<T>(
  Map<String, dynamic> json,
  String key,
) {
  if (json.containsKey(key) && json[key] != null) {
    List<dynamic> list = getJsonValue(json, key);

    final mapper = (it) {
      if (it is T) {
        return it;
      } else {
        throw SchemeConsistencyException(
          'Wrong type by key "$key", expected: "List<$T>" '
          'but has got element in list of type: "${it.runtimeType}"',
        );
      }
    };

    return Optional.of(list.length == 0 ? <T>[] : list.map(mapper).toList());
  } else {
    return Optional.empty();
  }
}
