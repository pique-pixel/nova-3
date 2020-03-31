import 'package:flutter_test/flutter_test.dart';
import 'package:json_models_generator/helpers.dart';

void main() {
  test('parse primitive', () async {
    expect(FieldType(isPrimitive: true, name: 'int', displayName: 'int'), parseType('int'));
    expect(FieldType(isPrimitive: true, name: 'String', displayName: 'String'), parseType('String'));
    expect(FieldType(isPrimitive: true, name: 'bool', displayName: 'bool'), parseType('bool'));
    expect(FieldType(isPrimitive: true, name: 'num', displayName: 'num'), parseType('num'));
    expect(FieldType(isPrimitive: true, name: 'num', displayName: 'num'), parseType(' num'));
  });

  test('parse non primitive', () async {
    expect(FieldType(isPrimitive: false, name: 'Box', displayName: 'Box'), parseType('Box'));
  });

  test('parse generic', () async {
    expect(
      parseType('Box<int>'),
      FieldType(
        isPrimitive: false,
        name: 'Box',
        displayName: 'Box<int>',
        generics: [
          FieldType(
            isPrimitive: true,
            name: 'int',
            displayName: 'int',
          )
        ],
      ),
    );
  });

  test('parse nested generic', () async {
    expect(
      parseType('Box<Optional<int>>'),
      FieldType(
        isPrimitive: false,
        name: 'Box',
        displayName: 'Box<Optional<int>>',
        generics: [
          FieldType(
            isPrimitive: false,
            name: 'Optional',
            displayName: 'Optional<int>',
            generics: [
              FieldType(
                isPrimitive: true,
                name: 'int',
                displayName: 'int',
              ),
            ],
          ),
        ],
      ),
    );
  });

  test('parse multiple generic', () async {
    expect(
      parseType('Map<String, int>'),
      FieldType(
        isPrimitive: false,
        name: 'Map',
        displayName: 'Map<String, int>',
        generics: [
          FieldType(
            isPrimitive: true,
            name: 'String',
            displayName: 'String',
          ),
          FieldType(
            isPrimitive: true,
            name: 'int',
            displayName: 'int',
          ),
        ],
      ),
    );
  });

  test('parse multiple nested generic', () async {
    expect(
      parseType('Map<Optional<String>, int>'),
      FieldType(
        isPrimitive: false,
        name: 'Map',
        displayName: 'Map<Optional<String>, int>',
        generics: [
          FieldType(
            name: 'Optional',
            displayName: 'Optional<String>',
            isPrimitive: false,
            generics: [
              FieldType(
                isPrimitive: true,
                name: 'String',
                displayName: 'String',
              ),
            ],
          ),
          FieldType(
            isPrimitive: true,
            name: 'int',
            displayName: 'int',
          ),
        ],
      ),
    );
  });

  test('remove Scheme', () async {
    expect(
      parseType('TestScheme'),
      FieldType(
        isPrimitive: false,
        name: 'Test',
        displayName: 'Test',
      ),
    );
  });

  test('remove Scheme', () async {
    expect(
      parseType('List<TestScheme>'),
      FieldType(
        isPrimitive: false,
        name: 'List',
        displayName: 'List<Test>',
        generics: [
          FieldType(
            name: 'Test',
            displayName: 'Test',
            isPrimitive: false,
          ),
        ],
      ),
    );
  });

  test('remove Scheme', () async {
    expect(
      parseType('List<ListScheme<TestScheme>>'),
      FieldType(
        isPrimitive: false,
        name: 'List',
        displayName: 'List<List<Test>>',
        generics: [
          FieldType(
            name: 'List',
            displayName: 'List<Test>',
            isPrimitive: false,
            generics: [
              FieldType(
                name: 'Test',
                displayName: 'Test',
                isPrimitive: false,
              ),
            ],
          ),
        ],
      ),
    );
  });
}
