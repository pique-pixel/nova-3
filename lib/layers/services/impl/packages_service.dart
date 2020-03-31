import 'package:flutter/cupertino.dart';
import 'package:rp_mobile/containers/page.dart';
import 'package:rp_mobile/layers/bloc/services_package_details/services_package_details_models.dart';
import 'package:rp_mobile/layers/bloc/services_package_list/services_package_list_models.dart';
import 'package:rp_mobile/layers/services/packages_service.dart';
import 'package:rp_mobile/layers/drivers/api/gateway.dart';
import 'package:rp_mobile/layers/adapters/ui_models_factory.dart';
import 'package:rp_mobile/layers/services/session.dart';
import 'package:rp_mobile/utils/future.dart';

class PackagesServiceImpl implements PackagesService {
  final ApiGateway _apiGateway;
  final UiModelsFactory _uiModelsFactory;
  final SessionService _sessionService;

//  final contents = <String, PackageDetailResponse>{};

  PackagesServiceImpl(
      this._apiGateway,
      this._uiModelsFactory,
      this._sessionService,
      );

  @override
  Future<Page<PackageItemModel>> getPackageItems([int page = 1]) async {

  }

  @override
  Future<List<SectionModel>> getPackageDetails(String ref,
  ) => _sessionService.refreshSessionOnUnauthorized(() async {
  final response = await _apiGateway.getPackageDetails(ref);

  final PackageDetail packageDetail = _uiModelsFactory.createPackageDetails(response);

  return <SectionModel>[
    packageDetail.header,
    packageDetail.services,
    packageDetail.activities,
  ];
});

  @override
  Future<ActivitiesSection> getAllPackageActivities(
      String ref, [
        List<String> filter = const [],
      ]) async {

  }

  @override
  Future<ActivitiesSection> filterPackageActivities(
      String ref,
      List<String> filters,
      bool loadAllActivities,
      ) async {

  }

  @override
  Future<List<SectionModel>> getPackageDetailsForCity(
      String ref,
      String cityRef,
      ) async {

  }
}