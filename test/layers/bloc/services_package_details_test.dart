import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rp_mobile/layers/bloc/services_package_details/bloc.dart';
import 'package:rp_mobile/layers/services/packages_service.dart';

class MockPackagesService extends Mock implements PackagesService {}

class MockSectionModel extends SectionModel {
  @override
  List<Object> get props => [];
}

void main() {
  test('default initial state is correct', () async {
    final bloc = ServicesPackageDetailsBloc('1', MockPackagesService());
    expect(bloc.initialState, InitialServicesPackageDetailsState());
    bloc.close();
  });

  final mockActivitiesSection =
      (bool isExpanded, bool isFiltered) => ActivitiesSection(
            title: '',
            filters: [
              ActivityFilter(ref: 'f1', title: 'f1', isActive: isFiltered),
              ActivityFilter(ref: 'f2', title: 'f2', isActive: isFiltered),
            ],
            activities: [
              ActivityModel(thumbnailUrl: '1', title: '6'),
              ActivityModel(thumbnailUrl: '2', title: '7'),
              ActivityModel(thumbnailUrl: '3', title: '8'),
              ActivityModel(thumbnailUrl: '4', title: '9'),
              ActivityModel(thumbnailUrl: '5', title: '10'),
            ],
            description: 'Lorem ipsum',
            isLoadedAllItems: isExpanded,
          );

  final mockFilteredActivitiesSection = (bool isExpanded) => ActivitiesSection(
        title: '',
        filters: [
          ActivityFilter(ref: 'f1', title: 'f1', isActive: true),
          ActivityFilter(ref: 'f2', title: 'f2', isActive: true),
        ],
        activities: [
          ActivityModel(thumbnailUrl: '1', title: '6'),
          ActivityModel(thumbnailUrl: '2', title: '7'),
          ActivityModel(thumbnailUrl: '3', title: '8'),
        ],
        description: 'Lorem ipsum',
        isLoadedAllItems: isExpanded,
      );

  final mockData = ({isFiltered = false}) => <SectionModel>[
        MockSectionModel(),
        MockSectionModel(),
        MockSectionModel(),
        mockActivitiesSection(false, isFiltered),
      ];

  final mockDataChangeCity = ({isFiltered = false}) => <SectionModel>[
        MockSectionModel(),
        MockSectionModel(),
        MockSectionModel(),
        MockSectionModel(),
        MockSectionModel(),
        MockSectionModel(),
        mockActivitiesSection(false, isFiltered),
      ];

  final mockDataExpanded = (isFiltered) => <SectionModel>[
        MockSectionModel(),
        MockSectionModel(),
        MockSectionModel(),
        mockActivitiesSection(true, isFiltered),
      ];

  final mockDataFiltered = (bool isExpanded) => <SectionModel>[
        MockSectionModel(),
        MockSectionModel(),
        MockSectionModel(),
        mockFilteredActivitiesSection(isExpanded),
      ];

  PackagesService createPackagesService({
    bool hasError = false,
    bool filterError = false,
    bool loadAllActivitiesError = false,
    bool changeCityError = false,
  }) {
    final service = MockPackagesService();

    if (hasError) {
      when(service.getPackageDetails(any)).thenThrow(AssertionError());
    } else {
      when(service.getPackageDetails(any))
          .thenAnswer((_) => Future.value(mockData(isFiltered: false)));
    }

    if (filterError) {
      when(service.filterPackageActivities(any, any, any))
          .thenThrow(AssertionError());
    } else {
      when(service.filterPackageActivities(any, any, false)).thenAnswer(
        (_) => Future.value(mockFilteredActivitiesSection(false)),
      );

      when(service.filterPackageActivities(any, any, true)).thenAnswer(
        (_) => Future.value(mockFilteredActivitiesSection(true)),
      );
    }

    if (loadAllActivitiesError) {
      when(service.getAllPackageActivities(any, any))
          .thenThrow(AssertionError());
    } else {
      when(service.getAllPackageActivities(any, []))
          .thenAnswer((_) => Future.value(mockActivitiesSection(true, false)));

      when(service.getAllPackageActivities(any, ['f1', 'f2']))
          .thenAnswer((_) => Future.value(mockFilteredActivitiesSection(true)));
    }

    if (changeCityError) {
      when(service.getPackageDetailsForCity(any, any))
          .thenThrow(AssertionError());
    } else {
      when(service.getPackageDetailsForCity(any, any))
          .thenAnswer((_) => Future.value(mockDataChangeCity()));
    }

    return service;
  }

  test('failed loading details', () async {
    final packagesService = createPackagesService(hasError: true);
    final bloc = ServicesPackageDetailsBloc('1', packagesService);

    bloc.add(OnLoad());

    await expectLater(
      bloc,
      emitsInOrder([
        InitialServicesPackageDetailsState(),
        LoadingState(),
        LoadingErrorState(),
      ]),
    );

    verify(packagesService.getPackageDetails('1'));
    verifyNoMoreInteractions(packagesService);

    bloc.close();
  });

  test('success loaded details', () async {
    final packagesService = createPackagesService(hasError: false);
    final bloc = ServicesPackageDetailsBloc('1', packagesService);

    bloc.add(OnLoad());

    await expectLater(
      bloc,
      emitsInOrder([
        InitialServicesPackageDetailsState(),
        LoadingState(),
        LoadedState(mockData(isFiltered: false)),
      ]),
    );

    verify(packagesService.getPackageDetails('1'));
    verifyNoMoreInteractions(packagesService);

    bloc.close();
  });

  test('failed change city', () async {
    final packagesService = createPackagesService(changeCityError: true);
    final bloc = ServicesPackageDetailsBloc('1', packagesService);

    bloc.add(OnLoad());
    bloc.add(OnChangeCity('1'));

    await expectLater(
      bloc,
      emitsInOrder([
        InitialServicesPackageDetailsState(),
        LoadingState(),
        LoadedState(mockData(isFiltered: false)),
        LoadingState(),
        LoadedState(mockData(isFiltered: false)),
      ]),
    );

    verify(packagesService.getPackageDetails('1'));
    verify(packagesService.getPackageDetailsForCity('1', '1'));
    verifyNoMoreInteractions(packagesService);

    bloc.close();
  });

  test('success changed city', () async {
    final packagesService = createPackagesService();
    final bloc = ServicesPackageDetailsBloc('1', packagesService);

    bloc.add(OnLoad());
    bloc.add(OnChangeCity('1'));

    await expectLater(
      bloc,
      emitsInOrder([
        InitialServicesPackageDetailsState(),
        LoadingState(),
        LoadedState(mockData(isFiltered: false)),
        LoadingState(),
        LoadedState(mockDataChangeCity()),
      ]),
    );

    verify(packagesService.getPackageDetails('1'));
    verify(packagesService.getPackageDetailsForCity('1', '1'));
    verifyNoMoreInteractions(packagesService);

    bloc.close();
  });

  test('expand activities failed', () async {
    final packagesService = createPackagesService(loadAllActivitiesError: true);
    final bloc = ServicesPackageDetailsBloc('1', packagesService);

    bloc.add(OnLoad());
    bloc.add(OnExpandActivities());

    await expectLater(
      bloc,
      emitsInOrder([
        InitialServicesPackageDetailsState(),
        LoadingState(),
        LoadedState(mockData(isFiltered: false)),
        LoadingAllActivitiesState(mockData(isFiltered: false)),
        LoadedState(mockData(isFiltered: false)),
      ]),
    );

    verify(packagesService.getPackageDetails('1'));
    verify(packagesService.getAllPackageActivities('1'));
    verifyNoMoreInteractions(packagesService);

    bloc.close();
  });

  test('expand activities success', () async {
    final packagesService = createPackagesService();
    final bloc = ServicesPackageDetailsBloc('1', packagesService);

    bloc.add(OnLoad());
    bloc.add(OnExpandActivities());

    await expectLater(
      bloc,
      emitsInOrder([
        InitialServicesPackageDetailsState(),
        LoadingState(),
        LoadedState(mockData(isFiltered: false)),
        LoadingAllActivitiesState(mockData(isFiltered: false)),
        LoadedState(mockDataExpanded(false)),
      ]),
    );

    verify(packagesService.getPackageDetails('1'));
    verify(packagesService.getAllPackageActivities('1'));
    verifyNoMoreInteractions(packagesService);

    bloc.close();
  });

  test('filter activities failed - not expanded', () async {
    final packagesService = createPackagesService(filterError: true);
    final bloc = ServicesPackageDetailsBloc('1', packagesService);

    bloc.add(OnLoad());
    bloc.add(OnFilterActivities(['f1', 'f2']));

    await expectLater(
      bloc,
      emitsInOrder([
        InitialServicesPackageDetailsState(),
        LoadingState(),
        LoadedState(mockData(isFiltered: false)),
        FilteringActivitiesState(mockData(isFiltered: true)),
        LoadedState(mockData(isFiltered: false)),
      ]),
    );

    verify(packagesService.getPackageDetails('1'));
    verify(packagesService.filterPackageActivities('1', ['f1', 'f2'], false));
    verifyNoMoreInteractions(packagesService);

    bloc.close();
  });

  test('filter activities failed - expanded', () async {
    final packagesService = createPackagesService(filterError: true);
    final bloc = ServicesPackageDetailsBloc('1', packagesService);

    bloc.add(OnLoad());
    bloc.add(OnExpandActivities());
    bloc.add(OnFilterActivities(['f1', 'f2']));

    await expectLater(
      bloc,
      emitsInOrder([
        InitialServicesPackageDetailsState(),
        LoadingState(),
        LoadedState(mockData(isFiltered: false)),
        LoadingAllActivitiesState(mockData(isFiltered: false)),
        LoadedState(mockDataExpanded(false)),
        FilteringActivitiesState(mockDataExpanded(true)),
        LoadedState(mockDataExpanded(false)),
      ]),
    );

    verify(packagesService.getPackageDetails('1'));
    verify(packagesService.getAllPackageActivities('1'));
    verify(packagesService.filterPackageActivities('1', ['f1', 'f2'], true));
    verifyNoMoreInteractions(packagesService);

    bloc.close();
  });

  test('filter activities success - not expanded', () async {
    final packagesService = createPackagesService();
    final bloc = ServicesPackageDetailsBloc('1', packagesService);

    bloc.add(OnLoad());
    bloc.add(OnFilterActivities(['f1', 'f2']));

    await expectLater(
      bloc,
      emitsInOrder([
        InitialServicesPackageDetailsState(),
        LoadingState(),
        LoadedState(mockData(isFiltered: false)),
        FilteringActivitiesState(mockData(isFiltered: true)),
        LoadedState(mockDataFiltered(false)),
      ]),
    );

    verify(packagesService.getPackageDetails('1'));
    verify(packagesService.filterPackageActivities('1', ['f1', 'f2'], false));
    verifyNoMoreInteractions(packagesService);

    bloc.close();
  });

  test('filter activities success - expanded', () async {
    final packagesService = createPackagesService();
    final bloc = ServicesPackageDetailsBloc('1', packagesService);

    bloc.add(OnLoad());
    bloc.add(OnExpandActivities());
    bloc.add(OnFilterActivities(['f1', 'f2']));

    await expectLater(
      bloc,
      emitsInOrder([
        InitialServicesPackageDetailsState(),
        LoadingState(),
        LoadedState(mockData(isFiltered: false)),
        LoadingAllActivitiesState(mockData(isFiltered: false)),
        LoadedState(mockDataExpanded(false)),
        FilteringActivitiesState(mockDataExpanded(true)),
        LoadedState(mockDataFiltered(true)),
      ]),
    );

    verify(packagesService.getPackageDetails('1'));
    verify(packagesService.getAllPackageActivities('1'));
    verify(packagesService.filterPackageActivities('1', ['f1', 'f2'], true));
    verifyNoMoreInteractions(packagesService);

    bloc.close();
  });

  test('filter activities success - spamming', () async {
    final packagesService = createPackagesService();
    final bloc = ServicesPackageDetailsBloc('1', packagesService);

    bloc.add(OnLoad());
    bloc.add(OnExpandActivities());
    bloc.add(OnFilterActivities(['f1']));
    bloc.add(OnFilterActivities(['f1', 'f2']));

    await expectLater(
      bloc,
      emitsInOrder([
        InitialServicesPackageDetailsState(),
        LoadingState(),
        LoadedState(mockData(isFiltered: false)),
        LoadingAllActivitiesState(mockData(isFiltered: false)),
        LoadedState(mockDataExpanded(false)),
        FilteringActivitiesState(mockDataExpanded(true)),
        LoadedState(mockDataFiltered(true)),
      ]),
    );

    verify(packagesService.getPackageDetails('1'));
    verify(packagesService.getAllPackageActivities('1'));
    verify(packagesService.filterPackageActivities('1', ['f1', 'f2'], true));
    verifyNoMoreInteractions(packagesService);

    bloc.close();
  });

  test('expand filtered activities failed', () async {
    final packagesService = createPackagesService(loadAllActivitiesError: true);
    final bloc = ServicesPackageDetailsBloc('1', packagesService);

    bloc.add(OnLoad());
    bloc.add(OnFilterActivities(['f1', 'f2']));

    await expectLater(
      bloc,
      emitsInOrder([
        InitialServicesPackageDetailsState(),
        LoadingState(),
        LoadedState(mockData(isFiltered: false)),
        FilteringActivitiesState(mockData(isFiltered: true)),
        LoadedState(mockDataFiltered(false)),
      ]),
    );

    bloc.add(OnExpandActivities());

    await expectLater(
      bloc,
      emitsInOrder([
        LoadedState(mockDataFiltered(false)),
        LoadingAllActivitiesState(mockDataFiltered(false)),
        LoadedState(mockDataFiltered(false)),
      ]),
    );

    verify(packagesService.getPackageDetails('1'));
    verify(packagesService.filterPackageActivities('1', ['f1', 'f2'], false));
    verify(packagesService.getAllPackageActivities('1', ['f1', 'f2']));
    verifyNoMoreInteractions(packagesService);

    bloc.close();
  });

  test('expand filtered activities success', () async {
    final packagesService =
        createPackagesService(loadAllActivitiesError: false);
    final bloc = ServicesPackageDetailsBloc('1', packagesService);

    bloc.add(OnLoad());
    bloc.add(OnFilterActivities(['f1', 'f2']));

    await expectLater(
      bloc,
      emitsInOrder([
        InitialServicesPackageDetailsState(),
        LoadingState(),
        LoadedState(mockData(isFiltered: false)),
        FilteringActivitiesState(mockData(isFiltered: true)),
        LoadedState(mockDataFiltered(false)),
      ]),
    );

    bloc.add(OnExpandActivities());

    await expectLater(
      bloc,
      emitsInOrder([
        LoadedState(mockDataFiltered(false)),
        LoadingAllActivitiesState(mockDataFiltered(false)),
        LoadedState(mockDataFiltered(true)),
      ]),
    );

    verify(packagesService.getPackageDetails('1'));
    verify(packagesService.filterPackageActivities('1', ['f1', 'f2'], false));
    verify(packagesService.getAllPackageActivities('1', ['f1', 'f2']));
    verifyNoMoreInteractions(packagesService);

    bloc.close();
  });
}
