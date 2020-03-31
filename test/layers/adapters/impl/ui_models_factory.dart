import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rp_mobile/configs.dart';
import 'package:rp_mobile/layers/adapters/impl/ui_models_factory.dart';
import 'package:rp_mobile/layers/drivers/api/models.dart';

void main() {
  test('TicketsListResponse - success', () async {
    final file = File('test_resources/tickets_list.json');
    final json = jsonDecode(await file.readAsString());
    final model = TicketsListResponse.fromJson(json);

    final adapter = UiModelsFactoryImpl(devConfig());
    final page = adapter.createTicketsPage(model);

    expect('5df376b0bfc05200011fc86c', page.data[0].ref);
    expect(
      'https://api.russpass.iteco.dev/attach/image?file=content/1000311449.jpg',
      page.data[0].thumbnail.url,
    );
  });

  test('groupWeekDays', () async {
    final res = groupWeekDays([
      'WEDNESDAY',
      'SUNDAY',
      'FRIDAY',
      'SATURDAY',
      'THURSDAY',
    ]);

    expect(1, res.length);
    expect(WeeksGroup('WEDNESDAY', 'SUNDAY'), res[0]);
  });

  test('groupWeekDays 2', () async {
    final res = groupWeekDays([
      'MONDAY',
      'TUESDAY',
      'FRIDAY',
      'SATURDAY',
    ]);

    expect(2, res.length);
    expect(WeeksGroup('MONDAY', 'TUESDAY'), res[0]);
    expect(WeeksGroup('FRIDAY', 'SATURDAY'), res[1]);
  });

  test('groupWeekDays - length', () async {
    final res = groupWeekDays(
      [
        'MONDAY',
        'TUESDAY',
        'FRIDAY',
        'SATURDAY',
      ],
      2,
    );

    expect(4, res.length);
    expect(WeeksGroup('MONDAY', 'MONDAY'), res[0]);
    expect(WeeksGroup('TUESDAY', 'TUESDAY'), res[1]);
    expect(WeeksGroup('FRIDAY', 'FRIDAY'), res[2]);
    expect(WeeksGroup('SATURDAY', 'SATURDAY'), res[3]);
  });

  test('groupWeekDays - length 2', () async {
    final res = groupWeekDays(
      [
        'MONDAY',
        'TUESDAY',
        'WEDNESDAY',
        'FRIDAY',
        'SATURDAY',
      ],
      2,
    );

    expect(3, res.length);
    expect(WeeksGroup('MONDAY', 'WEDNESDAY'), res[0]);
    expect(WeeksGroup('FRIDAY', 'FRIDAY'), res[1]);
    expect(WeeksGroup('SATURDAY', 'SATURDAY'), res[2]);
  });

  test('groupWeekDays - one element', () async {
    final res = groupWeekDays(['MONDAY']);

    expect(1, res.length);
    expect(WeeksGroup('MONDAY', 'MONDAY'), res[0]);
  });

  test('groupWeekDays - two elements', () async {
    final res = groupWeekDays(['MONDAY', 'FRIDAY']);

    expect(2, res.length);
    expect(WeeksGroup('MONDAY', 'MONDAY'), res[0]);
    expect(WeeksGroup('FRIDAY', 'FRIDAY'), res[1]);
  });
}
