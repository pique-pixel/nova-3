import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rp_mobile/containers/page.dart';
import 'package:rp_mobile/layers/bloc/services_package_list/bloc.dart';
import 'package:rp_mobile/layers/services/packages_service.dart';

class MockPackagesService extends Mock implements PackagesService {}

// ignore: must_be_immutable
class MockPackageItemModel extends Mock implements PackageItemModel {}

void main() {
  test('default initial state is correct', () async {
    final bloc = ServicesPackageListBloc(MockPackagesService());
    expect(bloc.initialState, InitialServicesPackageListState());
    bloc.close();
  });

  final mockData = [
    Page<PackageItemModel>(
      nextPage: 2,
      data: [
        MockPackageItemModel(),
        MockPackageItemModel(),
        MockPackageItemModel(),
        MockPackageItemModel(),
      ],
    ),
    Page<PackageItemModel>(
      nextPage: null,
      data: [
        MockPackageItemModel(),
        MockPackageItemModel(),
        MockPackageItemModel(),
        MockPackageItemModel(),
      ],
    ),
  ];

  _mockPackageItemsGet(
    MockPackagesService service, {
    bool hasError = false,
    int page,
  }) {
    if (hasError) {
      when(service.getPackageItems(page)).thenThrow(AssertionError());
    } else {
      when(service.getPackageItems(page))
          .thenAnswer((_) => Future.value(mockData[page-1]));
    }
  }

  PackagesService createPackagesService({
    bool hasError = false,
    bool nextPageError = false,
  }) {
    final service = MockPackagesService();

    _mockPackageItemsGet(service, page: 1, hasError: hasError);
    _mockPackageItemsGet(service, page: 2, hasError: nextPageError);

    return service;
  }

  test('failed loading list', () async {
    final packagesService = createPackagesService(hasError: true);
    final bloc = ServicesPackageListBloc(packagesService);

    bloc.add(OnLoad());

    await expectLater(
      bloc,
      emitsInOrder([
        InitialServicesPackageListState(),
        LoadingListState(),
        LoadingListErrorState(),
      ]),
    );

    verify(packagesService.getPackageItems(1));
    verifyNoMoreInteractions(packagesService);

    bloc.close();
  });

  test('successfully loaded list', () async {
    final packagesService = createPackagesService();
    final bloc = ServicesPackageListBloc(packagesService);

    bloc.add(OnLoad());

    await expectLater(
      bloc,
      emitsInOrder([
        InitialServicesPackageListState(),
        LoadingListState(),
        LoadedState(mockData[0].data),
      ]),
    );

    verify(packagesService.getPackageItems(1));
    verifyNoMoreInteractions(packagesService);

    bloc.close();
  });

  test('load next page error', () async {
    final packagesService = createPackagesService(nextPageError: true);
    final bloc = ServicesPackageListBloc(packagesService);

    bloc.add(OnLoad());
    bloc.add(OnNextPage());

    await expectLater(
      bloc,
      emitsInOrder([
        InitialServicesPackageListState(),
        LoadingListState(),
        LoadedState(mockData[0].data),
        LoadingPageState(mockData[0].data),
        LoadedState(mockData[0].data),
      ]),
    );

    verify(packagesService.getPackageItems(1));
    verify(packagesService.getPackageItems(2));
    verifyNoMoreInteractions(packagesService);

    bloc.close();
  });

  test('load next page successfully', () async {
    final packagesService = createPackagesService();
    final bloc = ServicesPackageListBloc(packagesService);

    bloc.add(OnLoad());
    bloc.add(OnNextPage());

    await expectLater(
      bloc,
      emitsInOrder([
        InitialServicesPackageListState(),
        LoadingListState(),
        LoadedState(mockData[0].data),
        LoadingPageState(mockData[0].data),
        LoadedState([...mockData[0].data, ...mockData[1].data]),
      ]),
    );

    verify(packagesService.getPackageItems(1));
    verify(packagesService.getPackageItems(2));
    verifyNoMoreInteractions(packagesService);

    bloc.close();
  });

  test('refresh list error', () async {
    final packagesService = createPackagesService();
    final bloc = ServicesPackageListBloc(packagesService);

    bloc.add(OnLoad());
    bloc.add(OnNextPage());

    await expectLater(
      bloc,
      emitsInOrder([
        InitialServicesPackageListState(),
        LoadingListState(),
        LoadedState(mockData[0].data),
        LoadingPageState(mockData[0].data),
        LoadedState([...mockData[0].data, ...mockData[1].data]),
      ]),
    );

    verify(packagesService.getPackageItems(1));
    verify(packagesService.getPackageItems(2));

    _mockPackageItemsGet(packagesService, page: 1, hasError: true);
    bloc.add(OnRefresh());

    await expectLater(
      bloc,
      emitsInOrder([
        LoadedState([...mockData[0].data, ...mockData[1].data]),
        RefreshingListState([...mockData[0].data, ...mockData[1].data]),
        LoadedState([...mockData[0].data, ...mockData[1].data]),
      ]),
    );

    verify(packagesService.getPackageItems(1));
    verifyNoMoreInteractions(packagesService);

    bloc.close();
  });

  test('refresh list successfully', () async {
    final packagesService = createPackagesService();
    final bloc = ServicesPackageListBloc(packagesService);

    bloc.add(OnLoad());
    bloc.add(OnNextPage());
    bloc.add(OnRefresh());

    await expectLater(
      bloc,
      emitsInOrder([
        InitialServicesPackageListState(),
        LoadingListState(),
        LoadedState(mockData[0].data),
        LoadingPageState(mockData[0].data),
        LoadedState([...mockData[0].data, ...mockData[1].data]),
        RefreshingListState([...mockData[0].data, ...mockData[1].data]),
        LoadedState(mockData[0].data),
      ]),
    );

    verify(packagesService.getPackageItems(1));
    verify(packagesService.getPackageItems(2));
    verifyNoMoreInteractions(packagesService);

    bloc.close();
  });
}
