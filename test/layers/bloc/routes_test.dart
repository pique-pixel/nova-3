import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rp_mobile/layers/bloc/routes/bloc.dart';
import 'package:rp_mobile/layers/bloc/routes/routes_models.dart';
import 'package:rp_mobile/layers/services/geo_objects.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MockGeoObjectsService extends Mock implements GeoObjectsService {}

// ignore: must_be_immutable
class MockGeoObject extends Mock implements GeoObject {}

// ignore: must_be_immutable
class MockGeoObjectDetails extends Mock implements GeoObjectDetails {}

void main() {
  final mockDays = <Day>[
    Day(ref: '1', day: 'Сегодня'),
    Day(ref: '2', day: 'Завтра'),
  ];

  final mockDataDay1 = <GeoObject>[
    MockGeoObject(),
    MockGeoObject(),
  ];

  final mockDataDay2 = <GeoObject>[
    MockGeoObject(),
    MockGeoObject(),
    MockGeoObject(),
  ];

  final mockSuggestions = <SearchSuggestion>[
    SearchSuggestion(ref: '1', name: 'test 1'),
    SearchSuggestion(ref: '2', name: 'test 2'),
  ];

  final mockSuggestions2 = <SearchSuggestion>[
    SearchSuggestion(ref: '1', name: 'test 1'),
    SearchSuggestion(ref: '2', name: 'test 2'),
    SearchSuggestion(ref: '3', name: 'test 3'),
  ];

  final mockGeoObjectDetails = MockGeoObjectDetails();

  final currentGeoLocation = const Point(latitude: 10.0, longitude: 20.0);

  GeoObjectsService createGeoObjectsService({
    bool getGeoObjectsError = false,
    bool onSelectDayError = false,
    bool getDaysError = false,
    bool getGeoObjectsDetailsError = false,
    bool buildRouteError = false,
    bool getCurrentGeolocationError = false,
  }) {
    final service = MockGeoObjectsService();

    if (getGeoObjectsError) {
      when(service.getMapGeoObjects(any)).thenThrow(AssertionError());
    } else {
      when(service.getMapGeoObjects(null))
          .thenAnswer((_) => Future.value(mockDataDay1));

      if (onSelectDayError) {
        when(service.getMapGeoObjects('1')).thenThrow(AssertionError());
        when(service.getMapGeoObjects('2')).thenThrow(AssertionError());
      } else {
        when(service.getMapGeoObjects('1'))
            .thenAnswer((_) => Future.value(mockDataDay1));

        when(service.getMapGeoObjects('2'))
            .thenAnswer((_) => Future.value(mockDataDay2));
      }
    }

    if (getDaysError) {
      when(service.getDays()).thenThrow(AssertionError());
    } else {
      when(service.getDays()).thenAnswer((_) => Future.value(mockDays));
    }

    when(service.searchGeoObjects('error')).thenThrow(Exception());
    when(service.searchGeoObjects('ok'))
        .thenAnswer((_) => Future.value(mockSuggestions));

    when(service.searchGeoObjects('ok 2'))
        .thenAnswer((_) => Future.value(mockSuggestions2));

    if (getGeoObjectsDetailsError) {
      when(service.getGeoObjectsDetails(any)).thenThrow(AssertionError());
    } else {
      when(service.getGeoObjectsDetails(any))
          .thenAnswer((_) => Future.value(mockGeoObjectDetails));
    }

    if (getCurrentGeolocationError) {
      when(service.getCurrentGeoLocation()).thenThrow(AssertionError());
    } else {
      when(service.getCurrentGeoLocation())
          .thenAnswer((_) => Future.value(currentGeoLocation));
    }

    if (buildRouteError) {
      when(service.buildMasstransitRoute(any, any)).thenThrow(AssertionError());
    } else {
      when(service.buildMasstransitRoute(any, any)).thenAnswer((_) => Future.value());
    }

    return service;
  }

  test('default initial state is correct', () async {
    final bloc = RoutesBloc(MockGeoObjectsService());
    expect(bloc.initialState, InitialRoutesState());
    bloc.close();
  });

  test('loading error', () async {
    final service = createGeoObjectsService(getGeoObjectsError: true);
    final bloc = RoutesBloc(service);

    bloc.add(OnLoad());

    await expectLater(
      bloc,
      emitsInOrder([
        InitialRoutesState(),
        LoadingState(),
        LoadErrorState(),
      ]),
    );

    verify(service.getMapGeoObjects(null));
    bloc.close();
  });

  test('loading error 2', () async {
    final service = createGeoObjectsService(
      getGeoObjectsError: false,
      getDaysError: true,
    );
    final bloc = RoutesBloc(service);

    bloc.add(OnLoad());

    await expectLater(
      bloc,
      emitsInOrder([
        InitialRoutesState(),
        LoadingState(),
        LoadErrorState(),
      ]),
    );

    verify(service.getMapGeoObjects(null));
    verify(service.getDays());
    bloc.close();
  });

  test('loaded successfully', () async {
    final service = createGeoObjectsService();
    final bloc = RoutesBloc(service);

    bloc.add(OnLoad());

    await expectLater(
      bloc,
      emitsInOrder([
        InitialRoutesState(),
        LoadingState(),
        LoadedMapState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
      ]),
    );

    verify(service.getMapGeoObjects(null));
    verify(service.getDays());
    bloc.close();
  });

  test('select day error', () async {
    final service = createGeoObjectsService(onSelectDayError: true);
    final bloc = RoutesBloc(service);

    bloc.add(OnLoad());
    bloc.add(OnSelectDay('2'));

    await expectLater(
      bloc,
      emitsInOrder([
        InitialRoutesState(),
        LoadingState(),
        LoadedMapState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        LoadingState(),
        LoadedMapState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
      ]),
    );

    verify(service.getMapGeoObjects(null));
    verify(service.getDays());
    verify(service.getMapGeoObjects('2'));
    bloc.close();
  });

  test('select day successfully', () async {
    final service = createGeoObjectsService();
    final bloc = RoutesBloc(service);

    bloc.add(OnLoad());
    bloc.add(OnSelectDay('2'));

    await expectLater(
      bloc,
      emitsInOrder([
        InitialRoutesState(),
        LoadingState(),
        LoadedMapState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        LoadingState(),
        LoadedMapState(
          geoObjects: mockDataDay2,
          days: mockDays,
          selectedDayRef: '2',
        ),
      ]),
    );

    verify(service.getMapGeoObjects(null));
    verify(service.getDays());
    verify(service.getMapGeoObjects('2'));
    bloc.close();
  });

  test('search focus', () async {
    final service = createGeoObjectsService();
    final bloc = RoutesBloc(service);

    bloc.add(OnLoad());
    bloc.add(OnSearchFocus());

    await expectLater(
      bloc,
      emitsInOrder([
        InitialRoutesState(),
        LoadingState(),
        LoadedMapState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SearchState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
      ]),
    );

    verify(service.getMapGeoObjects(null));
    verify(service.getDays());
    bloc.close();
  });

  test('search loading suggestions error', () async {
    final service = createGeoObjectsService();
    final bloc = RoutesBloc(service);

    bloc.add(OnLoad());
    bloc.add(OnSearchFocus());
    bloc.add(OnSearch('error'));

    await expectLater(
      bloc,
      emitsInOrder([
        InitialRoutesState(),
        LoadingState(),
        LoadedMapState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SearchState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SearchLoadingSuggestionsState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SearchLoadSuggestionsErrorState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
      ]),
    );

    verify(service.getMapGeoObjects(null));
    verify(service.getDays());
    verify(service.searchGeoObjects('error'));
    bloc.close();
  });

  test('search successfully loaded suggestions', () async {
    final service = createGeoObjectsService();
    final bloc = RoutesBloc(service);

    bloc.add(OnLoad());
    bloc.add(OnSearchFocus());
    bloc.add(OnSearch('ok'));

    await expectLater(
      bloc,
      emitsInOrder([
        InitialRoutesState(),
        LoadingState(),
        LoadedMapState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SearchState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SearchLoadingSuggestionsState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SearchState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
          suggestions: mockSuggestions,
        ),
      ]),
    );

    verify(service.getMapGeoObjects(null));
    verify(service.getDays());
    verify(service.searchGeoObjects('ok'));
    bloc.close();
  });

  test('search debounce', () async {
    final service = createGeoObjectsService();
    final bloc = RoutesBloc(service);

    bloc.add(OnLoad());
    bloc.add(OnSearchFocus());
    bloc.add(OnSearch('ok'));
    bloc.add(OnSearch('ok 2'));

    await expectLater(
      bloc,
      emitsInOrder([
        InitialRoutesState(),
        LoadingState(),
        LoadedMapState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SearchState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SearchLoadingSuggestionsState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SearchState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
          suggestions: mockSuggestions2,
        ),
      ]),
    );

    verify(service.getMapGeoObjects(null));
    verify(service.getDays());
    verify(service.searchGeoObjects('ok 2'));

    bloc.close();
  });

  test('on cancel search', () async {
    final service = createGeoObjectsService();
    final bloc = RoutesBloc(service);

    bloc.add(OnLoad());
    bloc.add(OnSearchFocus());
    bloc.add(OnCancel());

    await expectLater(
      bloc,
      emitsInOrder([
        InitialRoutesState(),
        LoadingState(),
        LoadedMapState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SearchState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        LoadedMapState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
      ]),
    );

    verify(service.getMapGeoObjects(null));
    verify(service.getDays());

    bloc.close();
  });

  test('select geo object from map error', () async {
    final service = createGeoObjectsService(getGeoObjectsDetailsError: true);
    final bloc = RoutesBloc(service);

    bloc.add(OnLoad());
    bloc.add(OnSelectGeoObject('1'));

    await expectLater(
      bloc,
      emitsInOrder([
        InitialRoutesState(),
        LoadingState(),
        LoadedMapState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SelectGeoObjectLoadingState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        LoadedMapState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
      ]),
    );

    verify(service.getMapGeoObjects(null));
    verify(service.getDays());
    verify(service.getGeoObjectsDetails('1'));

    bloc.close();
  });

  test('select geo object from map successfully', () async {
    final service = createGeoObjectsService();
    final bloc = RoutesBloc(service);

    bloc.add(OnLoad());
    bloc.add(OnSelectGeoObject('1'));

    await expectLater(
      bloc,
      emitsInOrder([
        InitialRoutesState(),
        LoadingState(),
        LoadedMapState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SelectGeoObjectLoadingState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SelectedGeoObjectState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
          details: mockGeoObjectDetails,
        ),
      ]),
    );

    verify(service.getMapGeoObjects(null));
    verify(service.getDays());
    verify(service.getGeoObjectsDetails('1'));

    bloc.close();
  });

  test('select geo object from search error', () async {
    final service = createGeoObjectsService(getGeoObjectsDetailsError: true);
    final bloc = RoutesBloc(service);

    bloc.add(OnLoad());
    bloc.add(OnSearchFocus());
    bloc.add(OnSearch('ok'));

    await expectLater(
      bloc,
      emitsInOrder([
        InitialRoutesState(),
        LoadingState(),
        LoadedMapState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SearchState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SearchLoadingSuggestionsState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SearchState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
          suggestions: mockSuggestions,
        ),
      ]),
    );

    bloc.add(OnSelectGeoObject('1'));

    await expectLater(
      bloc,
      emitsInOrder([
        SearchState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
          suggestions: mockSuggestions,
        ),
        SelectGeoObjectLoadingState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SearchState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
          suggestions: mockSuggestions,
        ),
      ]),
    );

    verify(service.getMapGeoObjects(null));
    verify(service.getDays());
    verify(service.searchGeoObjects('ok'));
    verify(service.getGeoObjectsDetails('1'));

    bloc.close();
  });

  test('select geo object from search successfully', () async {
    final service = createGeoObjectsService();
    final bloc = RoutesBloc(service);

    bloc.add(OnLoad());
    bloc.add(OnSearchFocus());
    bloc.add(OnSearch('ok'));

    await expectLater(
      bloc,
      emitsInOrder([
        InitialRoutesState(),
        LoadingState(),
        LoadedMapState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SearchState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SearchLoadingSuggestionsState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SearchState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
          suggestions: mockSuggestions,
        ),
      ]),
    );

    bloc.add(OnSelectGeoObject('1'));

    await expectLater(
      bloc,
      emitsInOrder([
        SearchState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
          suggestions: mockSuggestions,
        ),
        SelectGeoObjectLoadingState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SelectedGeoObjectState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
          details: mockGeoObjectDetails,
        ),
      ]),
    );

    verify(service.getMapGeoObjects(null));
    verify(service.getDays());
    verify(service.searchGeoObjects('ok'));
    verify(service.getGeoObjectsDetails('1'));

    bloc.close();
  });

  test('cancel geo object details', () async {
    final service = createGeoObjectsService();
    final bloc = RoutesBloc(service);

    bloc.add(OnLoad());
    bloc.add(OnSelectGeoObject('1'));
    bloc.add(OnCancel());

    await expectLater(
      bloc,
      emitsInOrder([
        InitialRoutesState(),
        LoadingState(),
        LoadedMapState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SelectGeoObjectLoadingState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SelectedGeoObjectState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
          details: mockGeoObjectDetails,
        ),
        LoadedMapState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
      ]),
    );

    verify(service.getMapGeoObjects(null));
    verify(service.getDays());
    verify(service.getGeoObjectsDetails('1'));

    bloc.close();
  });

  test('build route error', () async {
    final service = createGeoObjectsService(buildRouteError: true);
    final bloc = RoutesBloc(service);

    bloc.add(OnLoad());
    bloc.add(OnSelectGeoObject('1'));
    bloc.add(OnBuildRoute());

    await expectLater(
      bloc,
      emitsInOrder([
        InitialRoutesState(),
        LoadingState(),
        LoadedMapState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SelectGeoObjectLoadingState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SelectedGeoObjectState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
          details: mockGeoObjectDetails,
        ),
        BuildingRouteState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
          details: mockGeoObjectDetails,
        ),
        SelectedGeoObjectState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
          details: mockGeoObjectDetails,
        ),
      ]),
    );

    verify(service.getMapGeoObjects(null));
    verify(service.getDays());
    verify(service.getGeoObjectsDetails('1'));
    verify(service.getCurrentGeoLocation());
    verify(service.buildMasstransitRoute(currentGeoLocation, any));

    bloc.close();
  });

  test('build route get current geo location error', () async {
    final service = createGeoObjectsService(getCurrentGeolocationError: true);
    final bloc = RoutesBloc(service);

    bloc.add(OnLoad());
    bloc.add(OnSelectGeoObject('1'));
    bloc.add(OnBuildRoute());

    await expectLater(
      bloc,
      emitsInOrder([
        InitialRoutesState(),
        LoadingState(),
        LoadedMapState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SelectGeoObjectLoadingState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SelectedGeoObjectState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
          details: mockGeoObjectDetails,
        ),
        BuildingRouteState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
          details: mockGeoObjectDetails,
        ),
        SelectedGeoObjectState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
          details: mockGeoObjectDetails,
        ),
      ]),
    );

    verify(service.getMapGeoObjects(null));
    verify(service.getDays());
    verify(service.getGeoObjectsDetails('1'));
    verify(service.getCurrentGeoLocation());

    bloc.close();
  });

  test('build route successfully', () async {
    final service = createGeoObjectsService();
    final bloc = RoutesBloc(service);

    bloc.add(OnLoad());
    bloc.add(OnSelectGeoObject('1'));
    bloc.add(OnBuildRoute());

    await expectLater(
      bloc,
      emitsInOrder([
        InitialRoutesState(),
        LoadingState(),
        LoadedMapState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SelectGeoObjectLoadingState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SelectedGeoObjectState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
          details: mockGeoObjectDetails,
        ),
        BuildingRouteState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
          details: mockGeoObjectDetails,
        ),
        RouteToGeoObjectState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
          details: mockGeoObjectDetails,
        ),
      ]),
    );

    verify(service.getMapGeoObjects(null));
    verify(service.getDays());
    verify(service.getGeoObjectsDetails('1'));
    verify(service.getCurrentGeoLocation());
    verify(service.buildMasstransitRoute(currentGeoLocation, any));

    bloc.close();
  });

  test('build route successfully', () async {
    final service = createGeoObjectsService();
    final bloc = RoutesBloc(service);

    bloc.add(OnLoad());
    bloc.add(OnSelectGeoObject('1'));
    bloc.add(OnBuildRoute());
    bloc.add(OnCancel());

    await expectLater(
      bloc,
      emitsInOrder([
        InitialRoutesState(),
        LoadingState(),
        LoadedMapState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SelectGeoObjectLoadingState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
        SelectedGeoObjectState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
          details: mockGeoObjectDetails,
        ),
        BuildingRouteState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
          details: mockGeoObjectDetails,
        ),
        RouteToGeoObjectState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
          details: mockGeoObjectDetails,
        ),
        LoadedMapState(
          geoObjects: mockDataDay1,
          days: mockDays,
          selectedDayRef: '1',
        ),
      ]),
    );

    verify(service.getMapGeoObjects(null));
    verify(service.getDays());
    verify(service.getGeoObjectsDetails('1'));
    verify(service.getCurrentGeoLocation());
    verify(service.buildMasstransitRoute(currentGeoLocation, any));

    bloc.close();
  });
}
