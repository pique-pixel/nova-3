import 'package:flutter_test/flutter_test.dart';
import 'package:rp_mobile/containers/lifetime.dart';

void main() {
  test('isLeftover', () async {
    final model = LifeTimeModel<String>(
      'Test',
      createdAt: DateTime.now().subtract(Duration(days: 1)),
      lifeDuration: Duration(days: 2),
    );

    expect(await LifeTimeModel.isLeftover(model), equals(false));
  });

  test('isLeftover expired', () async {
    final model = LifeTimeModel<String>(
      'Test',
      createdAt: DateTime.now().subtract(Duration(days: 3)),
      lifeDuration: Duration(days: 2),
    );

    expect(await LifeTimeModel.isLeftover(model), equals(true));
  });

  test('LifeTime constructor', () async {
    final model = LifeTimeModel<String>(
      'Test',
      createdAt: DateTime.now().subtract(Duration(days: 3)),
      lifeDuration: Duration(days: 2),
    );

    final lifeTime = LifeTime<String>.defaultHandler(Duration(days: 2));
    expect(await lifeTime.isLeftoverHandler(model), equals(true));
    final lifeTimeInfinity = LifeTime<String>.infinity();
    expect(await lifeTimeInfinity.isLeftoverHandler(model), equals(false));
  });
}
