import 'package:matcher/matcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:optional/optional.dart';
import 'package:rp_mobile/exceptions.dart';
import 'package:rp_mobile/utils/json.dart';

void main() {
  test('getJsonValue - success', () {
    expect(getJsonValue({'key': 'value'}, 'key'), 'value');
  });

  test('getJsonValue - key error', () {
    expect(
      () => getJsonValue({'key2': 'value'}, 'key'),
      throwsA(const TypeMatcher<SchemeConsistencyException>()),
    );
  });

  test('getJsonValue - type error', () {
    expect(
      () => getJsonValue<String>({'key': 12}, 'key'),
      throwsA(const TypeMatcher<SchemeConsistencyException>()),
    );
  });

  test('getJsonValue - null', () {
    expect(
      () => getJsonValue({'key2': null}, 'key'),
      throwsA(const TypeMatcher<SchemeConsistencyException>()),
    );
  });

  test('getJsonValueOrEmpty - empty', () {
    expect(getJsonValueOrEmpty({'key': 'value'}, 'key2'), Optional.empty());
  });

  test('getJsonValueOrEmpty - success', () {
    expect(getJsonValueOrEmpty({'key': 'value'}, 'key'), Optional.of('value'));
  });

  test('getJsonValueOrEmpty - type error', () {
    expect(
      () => getJsonValueOrEmpty<String>({'key': 12}, 'key'),
      throwsA(const TypeMatcher<SchemeConsistencyException>()),
    );
  });

  test('transformJsonValueOrEmpty', () {
    expect(
        transformJsonValueOrEmpty(
          {'key': 'value'},
          'key',
          (value) => 12,
        ),
        Optional.of(12));
  });

  test('transformJsonValueOrEmpty - value', () {
    expect(
      transformJsonValueOrEmpty({'key': 'value'}, 'key', (value) => 12),
      Optional.of(12),
    );
  });

  test('transformJsonValueOrEmpty - empty', () {
    expect(
      transformJsonValueOrEmpty({'key': 'value'}, 'key1', (value) => 12),
      Optional.empty(),
    );
  });

  test('transformJsonValueOrEmpty - error', () {
    expect(
      () => transformJsonValueOrEmpty(
        {'key': 'value'},
        'key',
        (int value) => '12',
      ),
      throwsA(const TypeMatcher<SchemeConsistencyException>()),
    );
  });

  test('transformJsonListOfMap - value', () {
    expect(
      transformJsonListOfMap(
        {
          'array': [
            {'key': '1'},
            {'key': '2'},
          ]
        },
        'array',
        (it) => int.parse(getJsonValue(it, 'key')),
      ),
      <int>[1, 2],
    );
  });

  test('transformJsonListOfMap - not a list error', () {
    expect(
      () => transformJsonListOfMap(
        {'array': ':)'},
        'array',
        (it) => int.parse(getJsonValue(it, 'key')),
      ),
      throwsA(const TypeMatcher<SchemeConsistencyException>()),
    );
  });

  test('transformJsonListOfMap - transform error', () {
    expect(
      () => transformJsonListOfMap(
        {
          'array': [
            {'key': '1'},
            {'key': 'abc'},
          ]
        },
        'array',
        (it) => int.parse(getJsonValue(it, 'key')),
      ),
      throwsA(const TypeMatcher<SchemeConsistencyException>()),
    );
  });

  test('getJsonList - value', () {
    expect(
      getJsonList(
        {
          'array': ['1', '2']
        },
        'array',
      ),
      <String>['1', '2'],
    );
  });

  test('getJsonList - error', () {
    expect(
      () => getJsonList<String>(
        {
          'array': ['1', 2]
        },
        'array',
      ),
      throwsA(const TypeMatcher<SchemeConsistencyException>()),
    );
  });

  test('getJsonList - not a list error', () {
    expect(
      () => getJsonList<String>({'array': ':)'}, 'array'),
      throwsA(const TypeMatcher<SchemeConsistencyException>()),
    );
  });
}
