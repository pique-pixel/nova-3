import 'package:meta/meta.dart';
import 'package:rp_mobile/utils/network.dart';

class LifeTimeModel<T> {
  final T model;
  final DateTime createdAt;
  final Duration lifeDuration;

  LifeTimeModel(
    this.model, {
    this.createdAt,
    this.lifeDuration,
  });

  factory LifeTimeModel.of(T model, {@required Duration lifeDuration}) {
    return LifeTimeModel(
      model,
      createdAt: DateTime.now(),
      lifeDuration: lifeDuration,
    );
  }

  static Future<bool> isLeftover<T>(LifeTimeModel<T> lifeTime) async {
    if (lifeTime == null) {
      return true;
    }

    final expired = lifeTime.createdAt.add(lifeTime.lifeDuration);
    final now = DateTime.now();

    return now.compareTo(expired) > 0;
  }
}

class LifeTime<T> {
  final Duration duration;
  final Future<bool> Function(LifeTimeModel<T>) isLeftoverHandler;

  LifeTime({
    @required this.duration,
    this.isLeftoverHandler,
  });

  factory LifeTime.defaultHandler(Duration duration) {
    return LifeTime<T>(duration: duration, isLeftoverHandler: LifeTimeModel.isLeftover);
  }

  factory LifeTime.infinity() {
    return LifeTime<T>(duration: null, isLeftoverHandler: (_) async => false);
  }

  factory LifeTime.zero() {
    return LifeTime<T>(duration: null, isLeftoverHandler: (_) async => true);
  }

  // Если интернет есть, то объеуты всегда будут маркированы как пережитки (leftover)
  // если интернета нету, всегда будут браться ранее загруженный данные.
  factory LifeTime.connection() {
    return LifeTime<T>(
      duration: null,
      isLeftoverHandler: (_) async {
        return hasInternetConnection();
      },
    );
  }
}
