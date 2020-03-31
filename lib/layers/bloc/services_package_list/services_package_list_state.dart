import 'package:equatable/equatable.dart';

import 'services_package_list_models.dart';

abstract class ServicesPackageListState extends Equatable {
  const ServicesPackageListState();
}

class InitialServicesPackageListState extends ServicesPackageListState {
  @override
  List<Object> get props => [];
}

class LoadingListState extends ServicesPackageListState {
  @override
  List<Object> get props => [];
}

class LoadingListErrorState extends ServicesPackageListState {
  @override
  List<Object> get props => [];
}

class LoadedState extends ServicesPackageListState {
  final List<PackageItemModel> items;

  LoadedState(this.items);

  @override
  List<Object> get props => items;
}

class LoadingPageState extends LoadedState {
  LoadingPageState(List<PackageItemModel> items) : super(items);

  @override
  List<Object> get props => [];
}

class RefreshingListState extends LoadedState {
  RefreshingListState(List<PackageItemModel> items) : super(items);

  @override
  List<Object> get props => [];
}

