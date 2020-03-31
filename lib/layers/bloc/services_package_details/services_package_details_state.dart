import 'package:equatable/equatable.dart';
import 'package:rp_mobile/layers/bloc/services_package_details/services_package_details_models.dart';

abstract class ServicesPackageDetailsState extends Equatable {
  const ServicesPackageDetailsState();
}

class InitialServicesPackageDetailsState extends ServicesPackageDetailsState {
  @override
  List<Object> get props => [];
}

class LoadingState extends ServicesPackageDetailsState {
  @override
  List<Object> get props => [];
}

class LoadingErrorState extends ServicesPackageDetailsState {
  @override
  List<Object> get props => [];
}

class LoadedState extends ServicesPackageDetailsState {
  final List<SectionModel> sections;

  LoadedState(this.sections);

  @override
  List<Object> get props => sections;

  @override
  String toString() {
    return '$LoadedState($sections)';
  }
}

class LoadingAllActivitiesState extends LoadedState {
  LoadingAllActivitiesState(List<SectionModel> sections) : super(sections);
}

class FilteringActivitiesState extends LoadedState {
  FilteringActivitiesState(List<SectionModel> sections) : super(sections);
}
