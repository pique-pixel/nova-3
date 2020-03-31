import 'package:equatable/equatable.dart';

FieldType parseType(String type) {
  var newType = _parseType(type);
  return newType.copyWith(
    displayName: collectTypes(newType),
    name: _removeScheme(newType.name),
    generics: newType.generics,
  );
}

String collectTypes(FieldType type) {
  if (type.generics.isEmpty) {
    return _removeScheme(type.name);
  } else {
    final sub = type.generics.map((it) => collectTypes(it)).join(', ');
    final name = _removeScheme(type.name);
    return '$name<$sub>';
  }
}

String _removeScheme(String type) {
  if (type.endsWith('Scheme')) {
    return type.substring(0, type.length - 'Scheme'.length);
  } else {
    return type;
  }
}

FieldType _parseType(String type) {
  type = type.trim();

  if (isJsonPrimitive(type)) {
    return FieldType(name: type, displayName: type, isPrimitive: true);
  }

  type.indexOf('<');

  if (type.indexOf('<') == -1) {
    return FieldType(name: type, displayName: type, isPrimitive: false);
  }

  final String name = type.substring(0, type.indexOf('<'));
  final generic = type.substring(type.indexOf('<') + 1, type.length - 1);

  return FieldType(
    name: name,
    displayName: type,
    isPrimitive: false,
    generics: generic.split(',').map((it) => parseType(it.trim())).toList(),
  );
}

class FieldType extends Equatable {
  FieldType parent;
  final String name;
  final List<FieldType> generics;
  final bool isPrimitive;
  final String displayName;

  FieldType({
    this.parent,
    this.name,
    this.displayName,
    this.generics = const [],
    this.isPrimitive,
  })  : assert(name != null),
        assert(displayName != null),
        assert(generics != null),
        assert(isPrimitive != null)
  {
    for (final generic in generics) {
      generic.parent = this;
    }
  }

  @override
  List<Object> get props => [name, generics, isPrimitive, displayName];

  FieldType copyWith({
    String name,
    List<FieldType> generics,
    bool isPrimitive,
    String displayName,
  }) {
    return FieldType(
      name: name ?? this.name,
      generics: generics ?? this.generics,
      isPrimitive: isPrimitive ?? this.isPrimitive,
      displayName: displayName ?? this.displayName,
    );
  }

  @override
  String toString() =>
      'FieldType(name: $name, displayName: $displayName, isPrimitive: $isPrimitive, generic: $generics)';
}

bool isJsonPrimitive(String type) {
  return ['String', 'int', 'num', 'bool', 'double'].contains(type);
}
