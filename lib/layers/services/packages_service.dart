import 'package:rp_mobile/containers/page.dart';
import 'package:rp_mobile/layers/bloc/services_package_details/services_package_details_models.dart';
import 'package:rp_mobile/layers/bloc/services_package_list/services_package_list_models.dart';

abstract class PackagesService {
  Future<Page<PackageItemModel>> getPackageItems([int page = 1]);

  Future<List<SectionModel>> getPackageDetails(String ref);

  Future<ActivitiesSection> getAllPackageActivities(
    String ref, [
    List<String> filter = const [],
  ]);

  Future<ActivitiesSection> filterPackageActivities(
    String ref,
    List<String> filters,
    bool loadAllActivities,
  );

  Future<List<SectionModel>> getPackageDetailsForCity(
    String ref,
    String cityRef,
  );
}
