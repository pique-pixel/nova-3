import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:json_models_generator/helpers.dart';
import 'package:source_gen/source_gen.dart';

import 'annotations.dart';

class JsonSerializableGenerator extends GeneratorForAnnotation<JsonResponse> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      final name = element.name;
      throw InvalidGenerationSourceError(
        'Generator cannot target `$name`.',
        todo: 'Remove the JsonSerializable annotation from `$name`.',
        element: element,
      );
    }

    final classElement = element as ClassElement;
    var name = classElement.name;

    if (name.endsWith('Scheme')) {
      name = name.substring(0, name.length - 'Scheme'.length);
    } else {
      name = name + 'Response';
    }

    String result = 'class $name {\n';

    for (final field in classElement.fields) {
      final type = parseType(field.type.toString());
      final fieldName = field.name;

      if (_isEnum(type)) {
        result += '  final String $fieldName;\n';
      } else if (type.generics.length == 1 && _isEnum(type.generics[0])) {
        result += '  final ${type.name}<String> $fieldName;\n';
      } else if (type.name == 'Optional' &&
          type.generics[0].name == 'List' &&
          _isEnum(type.generics[0].generics[0])) {
        result += '  final Optional<List<String>> $fieldName;\n';
      } else {
        result += '  final ${type.displayName} $fieldName;\n';
      }
    }

    result += '\n';
    result += _factory(classElement, name);
    result += '\n';
    result += '  {\n';
    result += _validators(classElement);
    result += '  }\n';

    result += '}';

    return result;
  }

  String _validators(ClassElement classElement) {
    String result = '';

    final validate = classElement.methods
        .firstWhere((it) => it.name == 'validate', orElse: () => null);

    if (validate != null) {
      result += '    ${classElement.name}.validate(this);\n';
    }

    for (final field in classElement.fields) {
      final fieldName = field.name;
      final type = parseType(field.type.toString());

//      result += '    ';

      result +=
          '    require($fieldName != null, () => SchemeConsistencyException(\'"$fieldName" should not be null\'));\n';

      if (_isEnum(type)) {
        final acceptable = '${type.displayName}.acceptable';
        result +=
            '    require($acceptable.contains($fieldName), () => SchemeConsistencyException(\'"$fieldName" has a wrong value = \$$fieldName; acceptable values is: \${$acceptable}\'));\n';
      } else if (type.name == 'Optional' && _isEnum(type.generics[0])) {
        final acceptable = '${type.generics[0].displayName}.acceptable';

        result += '\n';
        result += '    if ($fieldName.isPresent) {\n';
        result += '      final value = $fieldName.value;\n';
        result +=
            '      require($acceptable.contains(value), () => SchemeConsistencyException(\'"$fieldName" has a wrong value = \$value; acceptable values is: \${$acceptable}\'));\n';
        result += '    }\n';
        result += '\n';
      } else if (type.name == 'List' && _isEnum(type.generics[0])) {
        final acceptable = '${type.generics[0].displayName}.acceptable';

        result += '\n';
        result += '    for (final value in $fieldName) {\n';
        result +=
            '      require($acceptable.contains(value), () => SchemeConsistencyException(\'"$fieldName" has a wrong value = \$value; acceptable values is: \${$acceptable}\'));\n';
        result += '    }\n';
        result += '\n';
      } else if (type.name == 'Optional' &&
          type.generics[0].name == 'List' &&
          _isEnum(type.generics[0].generics[0])) {
        final acceptable =
            '${type.generics[0].generics[0].displayName}.acceptable';

        result += '\n';
        result += '    if ($fieldName.isPresent) {\n';
        result += '      for (final value in $fieldName.value) {\n';
        result +=
            '        require($acceptable.contains(value), () => SchemeConsistencyException(\'"$fieldName" has a wrong value = \$value; acceptable values is: \${$acceptable}\'));\n';
        result += '      }\n';
        result += '    }\n';
        result += '\n';
      }
    }

    return result;
  }

  String _factory(ClassElement classElement, String name) {
    String result = '';

    result += '  $name.fromJson(Map<String, dynamic> json)\n';
    result += '      : ';
    final margin = ' ' * 8;

    for (final field in classElement.fields) {
      final fieldName = field.name;
      final typeName = field.type.toString();
      final type = parseType(typeName);

      result += '$fieldName = ' + _accessor(type, fieldName) + ',\n';
      result += margin;
    }

    // Remove last margin and last comma
    result = result.substring(0, result.length - margin.length - 2);
    return result;
  }

  String _accessor(FieldType type, String fieldName, [String accessor]) {
    final typeName = type.displayName;

    if (accessor == null) {
      accessor = 'getJsonValue(json, \'$fieldName\')';
    }

    if (_isEnum(type)) {
      type = FieldType(
        name: 'String',
        displayName: 'String',
        isPrimitive: true,
      );
    }

    if (type.isPrimitive) {
      return accessor;
    } else if (type.generics.isEmpty) {
      return '$typeName.fromJson($accessor)';
    } else if (type.name == 'Optional') {
      return _optionalAccessor(type.generics[0], fieldName);
    } else if (type.name == 'List') {
      final subType = type.generics[0];

      if (subType.isPrimitive || _isEnum(subType)) {
        String subTypeName;

        if (_isEnum(subType)) {
          subTypeName = 'String';
        } else {
          subTypeName = subType.displayName;
        }

        return 'getJsonList<$subTypeName>(json, \'$fieldName\')';
      } else {
        final subAccessor = _accessor(type.generics[0], null, 'it');
        return 'transformJsonListOfMap(json, \'$fieldName\', (it) => $subAccessor)';
      }
    } else {
      throw UnsupportedError('Unsupported type: $typeName');
    }
  }

  // TODO: merge with _accessor
  String _optionalAccessor(FieldType type, String fieldName,
      [String accessor]) {
    final typeName = type.displayName;

    if (accessor == null) {
      accessor = 'getJsonValueOrEmpty(json, \'$fieldName\')';
    }

    if (type.isPrimitive || _isEnum(type)) {
      return accessor;
    } else if (type.generics.isEmpty) {
      final subAccessor = _accessor(type, null, 'it');
      return 'transformJsonValueOrEmpty(json, \'$fieldName\', (it) => $subAccessor)';
    } else if (type.name == 'List') {
      final subType = type.generics[0];

      if (subType.isPrimitive || _isEnum(subType)) {
        String subTypeName;

        if (_isEnum(subType)) {
          subTypeName = 'String';
        } else {
          subTypeName = subType.displayName;
        }

        return 'getJsonListOrEmpty<$subTypeName>(json, \'$fieldName\')';
      } else {
        final subAccessor = _accessor(type.generics[0], null, 'it');
        return 'transformJsonListOfMapOrEmpty(json, \'$fieldName\', (it) => $subAccessor)';
      }
    } else {
      throw UnsupportedError('Unsupported type: $typeName');
    }
  }

  bool _isEnum(FieldType type) {
    return type.generics.isEmpty && type.displayName.startsWith('Enum');
  }
}
