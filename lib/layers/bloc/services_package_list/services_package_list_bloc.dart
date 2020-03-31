import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rp_mobile/containers/page.dart';
import 'package:rp_mobile/layers/services/packages_service.dart';
import './bloc.dart';

class ServicesPackageListBloc
    extends Bloc<ServicesPackageListEvent, ServicesPackageListState> {
  final PackagesService _packagesService;
  final _loadedItems = <PackageItemModel>[];
  Page _lastPage;

  ServicesPackageListState _checkpoint;

  ServicesPackageListBloc(this._packagesService);

  @override
  ServicesPackageListState get initialState =>
      InitialServicesPackageListState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    add(OnUnhandledException());
  }

  @override
  Stream<ServicesPackageListState> mapEventToState(
    ServicesPackageListEvent event,
  ) async* {
    if (event is OnUnhandledException) {
      if (_checkpoint == null ||
          _checkpoint is InitialServicesPackageListState) {
        yield LoadingListErrorState();
      } else {
        yield _checkpoint;
      }

      _checkpoint = null;
    } else if (event is OnLoad) {
      _checkpoint = state;
      yield* _loadList();
    } else if (event is OnNextPage) {
      _checkpoint = state;
      yield* _loadNextPage();
    } else if (event is OnRefresh) {
      _checkpoint = state;
      yield* _refreshList();
    } else {
      _checkpoint = state;
      throw UnsupportedError('Unsupported event: $event');
    }
  }

  Stream<ServicesPackageListState> _loadList() async* {
    yield LoadingListState();
    final page = await _packagesService.getPackageItems();

    _lastPage = page;
    _loadedItems.clear();
    _loadedItems.addAll(page.data);

    yield LoadedState(_loadedItems);
  }

  Stream<ServicesPackageListState> _loadNextPage() async* {
    if (_lastPage?.isLastPage ?? true) {
      return;
    }

    assert(state is LoadedState);

    yield LoadingPageState((state as LoadedState).items);
    final page = await _packagesService.getPackageItems(_lastPage.nextPage);

    _lastPage = page;
    _loadedItems.addAll(page.data);

    yield LoadedState(_loadedItems);
  }

  Stream<ServicesPackageListState> _refreshList() async* {
    assert(state is LoadedState);
    yield RefreshingListState((state as LoadedState).items);
    final page = await _packagesService.getPackageItems();

    _lastPage = page;
    _loadedItems.clear();
    _loadedItems.addAll(page.data);

    yield LoadedState(_loadedItems);
  }
}
