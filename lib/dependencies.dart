import 'package:get_it/get_it.dart';
import 'package:rp_mobile/config.dart';
import 'package:rp_mobile/layers/adapters/impl/ui_models_factory.dart';
import 'package:rp_mobile/layers/adapters/ui_models_factory.dart';
import 'package:rp_mobile/layers/drivers/api/gateway.dart';
import 'package:rp_mobile/layers/drivers/api/gateway_impl.dart';
import 'package:rp_mobile/layers/drivers/dio_client.dart';
import 'package:rp_mobile/layers/drivers/errors.dart';
import 'package:rp_mobile/layers/services/impl/plans_service.dart';
import 'package:rp_mobile/layers/services/plans_service.dart';

import 'package:rp_mobile/layers/services/session.dart';
import 'package:rp_mobile/layers/services/auth.dart';
import 'package:rp_mobile/layers/services/geo_objects.dart';
import 'package:rp_mobile/layers/services/packages_service.dart';

import 'package:rp_mobile/layers/services/impl/session.dart';
import 'package:rp_mobile/layers/services/impl/auth.dart';
import 'package:rp_mobile/layers/services/impl/geo_objects.dart';
import 'package:rp_mobile/layers/services/impl/packages_service.dart';

import 'layers/services/favorite_services.dart';
import 'layers/services/impl/favorite_service.dart';
import 'layers/services/impl/tickets_service.dart';
import 'layers/services/tickets_services.dart';
import 'layers/services/impl/event_detail_service.dart';
import 'layers/services/event_detail_service.dart';
import 'layers/services/impl/restaurant_detail_service.dart';
import 'layers/services/restaurant_detail_service.dart';

setupDependencies(Config config) {
  final serviceLocator = GetIt.instance;

  GetIt.instance.registerSingleton<Config>(config);

  serviceLocator.registerLazySingleton<ApiGateway>(
    () => ApiGatewayImpl(
      DioClient(
        baseEndpoint: config.apiBaseUrl,
        logging: config.apiLogging,
      ),
      config,
    ),
  );
  GetIt.instance.registerSingleton<ErrorsProducer>(ErrorsProducer());

  serviceLocator.registerFactory<SessionService>(
    () => SessionServiceImpl(
      GetIt.instance<ApiGateway>(),
      config,
    ),
  );
  serviceLocator.registerFactory<AuthService>(
    () => AuthServiceImpl(
      GetIt.instance<ApiGateway>(),
      GetIt.instance<SessionService>(),
      GetIt.instance<Config>(),
    ),
  );
//  serviceLocator.registerFactory<PackagesService>(() => PackagesServiceMockImpl());
  serviceLocator.registerFactory<PackagesService>(
        () => PackagesServiceImpl(
      GetIt.instance<ApiGateway>(),
      GetIt.instance<UiModelsFactory>(),
      GetIt.instance<SessionService>(),
    ),
//      () => TicketsServiceMockImpl(),
  );
  serviceLocator.registerFactory<TicketsService>(
    () => TicketsServiceImpl(
      GetIt.instance<ApiGateway>(),
      GetIt.instance<UiModelsFactory>(),
      GetIt.instance<SessionService>(),
    ),
//      () => TicketsServiceMockImpl(),
  );
  serviceLocator.registerFactory<FavoriteService>(
    () => FavoriteServiceImpl(
      GetIt.instance<ApiGateway>(),
      GetIt.instance<UiModelsFactory>(),
      GetIt.instance<SessionService>(),
    ),
  );
  serviceLocator.registerFactory<UiModelsFactory>(
    () => UiModelsFactoryImpl(config),
  );
  serviceLocator.registerLazySingleton<PlansService>(
    () => PlansServiceImpl(
      GetIt.instance<ApiGateway>(),
      GetIt.instance<UiModelsFactory>(),
      GetIt.instance<SessionService>(),
    ),
//    () => PlansServiceMockImpl(),
  );
  serviceLocator.registerLazySingleton<GeoObjectsService>(
    () => GeoObjectsServiceImpl(
      GetIt.instance<ApiGateway>(),
      GetIt.instance<PlansService>(),
    ),
  );
  serviceLocator.registerFactory<EventDetailService>(
        () => EventDetailServiceImpl(
      GetIt.instance<ApiGateway>(),
      GetIt.instance<UiModelsFactory>(),
      GetIt.instance<SessionService>(),
    ),
  );
  serviceLocator.registerFactory<RestaurantDetailService>(
        () => RestaurantDetailServiceImpl(
      GetIt.instance<ApiGateway>(),
      GetIt.instance<UiModelsFactory>(),
      GetIt.instance<SessionService>(),
    ),
  );
}
