import 'dart:convert';
import 'dart:io';
import 'package:matcher/matcher.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:optional/optional_internal.dart';
import 'package:rp_mobile/exceptions.dart';
import 'package:rp_mobile/layers/drivers/api/models.dart';
import 'package:rp_mobile/utils/json.dart';

void main() {
  test('TicketsListResponse - success', () async {
    final file = File('test_resources/tickets_list.json');
    final json = jsonDecode(await file.readAsString());
    final model = TicketsListResponse.fromJson(json);

    expect(model.last, false);
    expect(model.content.length, 20);
    expect(model.content[3].qr, Optional.of('R23409odjfkjs4'));
    expect(
      model.content[1].items[0].item.externalId,
      '5df9fb46779af50001d26094',
    );
    expect(
      model.content[0].items[0].item.offerContent,
      Optional.empty(),
    );
    expect(
      model.content[1].items[0].item.offerContent.value.name.value,
      'Каток Mega Ice',
    );
    expect(
      model.content[1].items[0].item.offerContent.value.photo.url,
      'content/75594233670.jpg',
    );
    expect(
      model.content[1].items[0].item.offerContent.value.photo.description,
      Optional.empty(),
    );
  });

  test('TicketsListResponse - fail', () async {
    final file = File('test_resources/tickets_list_bad.json');
    final json = jsonDecode(await file.readAsString());

    expect(
      () => TicketsListResponse.fromJson(json),
      throwsA(const TypeMatcher<SchemeConsistencyException>()),
    );
  });

  test('OfferResponse - success', () async {
    final file = File('test_resources/offer_details.json');
    final json = jsonDecode(await file.readAsString());
    final model = OfferResponse.fromJson(json);

    expect(model.fullName.value, 'Центральный военно-морской музей');
    expect(model.durationMin, 90);
    expect(model.place.url, 'http://navalmuseum.ru');
    expect(model.place.headerPhoto.url, 'content/7559423369.jpg');
    expect(model.place.headerPhoto.description.value, 'Some description');
    expect(model.tags.length, 3);
    expect(model.tags[2].name.value, 'история');
  });

  test('OfferResponse - fail', () async {
    final file = File('test_resources/tickets_list.json');
    final json = jsonDecode(await file.readAsString());

    expect(
      () => OfferResponse.fromJson(json),
      throwsA(const TypeMatcher<SchemeConsistencyException>()),
    );
  });

  test('PlanViewLite - success', () async {
    final file = File('test_resources/plans.json');
    final json = jsonDecode(await file.readAsString());
    final models = transformJsonList(
      json,
      (it) => PlanViewLiteResponse.fromJson(it),
    );

    expect(models[0].id, '5e5e246949ce3200012f8c48');
    expect(models[0].name, 'Театры');
    expect(models[0].startDate, '25.03.2020');
    expect(models[0].endDate, '26.03.2020');

    expect(models[1].id, '5e5e3d14071c57000146757d');
    expect(models[1].name, 'Музеи');
    expect(models[1].startDate, '29.03.2020');
    expect(models[1].endDate, '29.03.2020');
    expect(models[1].images[0].url, 'https://russpass.technolab.com.ru/v1/file/636b4816-1a67-45e0-a854-c41aa92b40c3');
    expect(models[1].images[1].url, 'https://russpass.technolab.com.ru/v1/file/2f3dff4e-d1c6-4902-a760-559869e4029a');
  });

  test('PlanDetailedViewResponse - success', () async {
    final file = File('test_resources/plan_details.json');
    final json = jsonDecode(await file.readAsString());
    PlanDetailedViewResponse.fromJson(json);
  });
}
