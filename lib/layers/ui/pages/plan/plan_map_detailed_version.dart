import 'dart:async';
import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:division/division.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:optional/optional.dart';
import 'package:rp_mobile/containers/image.dart';
import 'package:rp_mobile/layers/bloc/plan_details/bloc.dart';
import 'package:rp_mobile/layers/bloc/plan_details/plan_models.dart';
import 'package:rp_mobile/layers/services/plans_service.dart';
import 'package:rp_mobile/layers/ui/pages/plan/single_text_input_bottom_sheet.dart';
import 'package:rp_mobile/layers/ui/pages/routes/path_details.dart';
import 'package:rp_mobile/layers/ui/widgets/app/alerts.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_bottom_sheet_decoration.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/widgets/base/bottom_sheet.dart';
import 'package:rp_mobile/layers/ui/widgets/temp_widgets/date_picker_own.dart';
import 'package:rp_mobile/layers/ui/widgets/temp_widgets/temp_text_style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../event_details.dart' as Ev;
import '../restaurant_detail.dart' as Re;

class PlanMapPageDetailedVersionProvider extends StatelessWidget {
  final String ref;

  const PlanMapPageDetailedVersionProvider(this.ref, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlanDetailsBloc>(
      create: (context) {
        return PlanDetailsBloc(GetIt.instance<PlansService>())
          ..add(OnLoadDetails(ref));
      },
      child: PlanMapPageDetailedVersion(),
    );
  }
}

PlanDetailsBloc _bloc(BuildContext context) =>
    BlocProvider.of<PlanDetailsBloc>(context);

class PlanMapPageDetailedVersion extends StatefulWidget {
  static Size scSize;

  const PlanMapPageDetailedVersion({Key key}) : super(key: key);

  static route(String ref) => MaterialPageRoute(
        builder: (context) {
          scSize = MediaQuery.of(context).size;
          return PlanMapPageDetailedVersionProvider(ref);
        },
      );

  @override
  _PlanMapPageDetailedVersionState createState() =>
      _PlanMapPageDetailedVersionState();
}

class _PlanMapPageDetailedVersionState
    extends State<PlanMapPageDetailedVersion> {
  final _pc = PanelController();

  static Size scSize = PlanMapPageDetailedVersion.scSize;
  double _initFabHeightGeneral = scSize.height * 0.56;
  double _panelHeightOpenGeneral = scSize.height * 0.86;
  double _panelHeightClosedGeneral = scSize.height * 0.55;

  double _initFabHeightDetailed = scSize.height * (190 / scSize.height + 0.01);
  double _panelHeightOpenDetailed = scSize.height * 0.66;
  double _panelHeightClosedDetailed = scSize.height * (190 / scSize.height);

  double _initFabHeightRoute = scSize.height * (190 / scSize.height + 0.01);
  double _panelHeightOpenRoute = scSize.height * 0.66;
  double _panelHeightClosedRoute = scSize.height * (190 / scSize.height);

  double _fabPos = 0;

  int pressedDataIndex = 0;

  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = _bloc(context).listen(_handleRouting);
  }

  @override
  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
    }

    super.dispose();
  }

  void _handleRouting(PlanDetailsState state) async {
    if (context == null) {
      return;
    }

    if (state is RouteToUpdatePlanNameState) {
      // ignore: close_sinks
      final bloc = _bloc(context);
      Navigator.of(context).push(
        ModalBottomSheetRoute(
          maxHeightFactory: 1,
          builder: (_) => BlocProvider.value(
            value: bloc,
            child: _UpdatePlanBottomSheetContent(),
          ),
          decoratorBuilder: (_, child) =>
              AppBottomSheetDecoration(child: child),
        ),
      );

      _bloc(context).add(OnTriggerRoute());
    }

    if (state is RouteToPlanListState) {
      Navigator.of(context).pop(state.isDeleted);
    }
  }

  double zoomButtonsTopCalculatingFunction({
    @required double x,
    @required double screenHeight,
    @required double topPadding,
    @required panelHeightOpen,
    @required panelHeightClosed,
  }) {
    double result = (screenHeight +
        topPadding -
        (x * (panelHeightOpen - panelHeightClosed))) /
        2 -
        panelHeightClosed * 0.65;
    return result;
  }

  double posButtonsTopCalculatingFunction({
    @required double x,
    @required initFabHeight,
    @required panelHeightOpen,
    @required panelHeightClosed,
  }) {
    return initFabHeight + x * (panelHeightOpen - panelHeightClosed);
  }

  _opacity({
    double x,
    double ratio = 1,
    bool isGeneral = true,
  }) {
    double result = (1 - x * ratio);
    if (x > 1) x = 1;
    return isGeneral ? result : 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      theme: AppThemes.materialAppTheme(),
      body: BlocBuilder<PlanDetailsBloc, PlanDetailsState>(
        builder: (context, state) {
          if (state is InitialLoadingDetailsState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final _yandexMap = YandexMap(
              onGeoObjectTap: (geoObject) {
                debugPrint('LATITUDE: ${geoObject.point.latitude}');
                debugPrint('LONGITUDE: ${geoObject.point.longitude}');
              },
              onMapCreated: (controller) async {
                final Function(String) onTapToMark = (String spotRef) async {
                  _bloc(context).add(OnSelectPlace(spotRef));
                };

                _bloc(context).add(OnYandexMapReady(controller, onTapToMark));
              },
            );

            final void Function(double pos) _onPanelSlide =
                (double pos) =>
                setState(() {
                  _fabPos = pos;
                });

            final BorderRadius _borderRadius = BorderRadius.only(
              topLeft: Radius.circular(6.0),
              topRight: Radius.circular(6.0),
            );

            final double _parallaxOffset = 0.5;

            return Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                BlocBuilder<PlanDetailsBloc, PlanDetailsState>(
                  builder: (context, state) {
                    double _panelHeightOpen;
                    double _panelHeightClosed;
                    bool backdropEnabled = false;
                    if (state is DetailedSliderState) {
                      _panelHeightOpen = _panelHeightOpenDetailed;
                      _panelHeightClosed = _panelHeightClosedDetailed;
                      backdropEnabled = false;
                    } else if (state is RouteSelectSliderState) {
                      _panelHeightOpen =
                      state.routeType == RouteTypes.masstransit
                      ? _panelHeightOpenRoute
                      : _panelHeightClosedRoute;
                      _panelHeightClosed = _panelHeightClosedRoute;
                    } else if (state is BuildingRouteState) {
                      _panelHeightOpen = _panelHeightClosedRoute;
                      _panelHeightClosed = _panelHeightClosedRoute;
                    } else {
                      _panelHeightOpen = _panelHeightOpenGeneral;
                      _panelHeightClosed = _panelHeightClosedGeneral;
                      backdropEnabled = false;
                    }

                    return SlidingUpPanel(
                      defaultPanelState: PanelState.CLOSED,
                      controller: _pc,
                      maxHeight: _panelHeightOpen,
                      minHeight: _panelHeightClosed,
                      backdropEnabled: backdropEnabled,
                      parallaxEnabled: true,
                      renderPanelSheet: true,
                      parallaxOffset: _parallaxOffset,
                      body: Padding(
                        padding: EdgeInsets.only(
                          bottom: _panelHeightClosed,
                        ),
                        child: _yandexMap,
                      ),
                      panelSnapping: true,
                      panelBuilder: (scrollController) {
                        if (state is DetailedSliderState) {
                          return _DetailedSlider(
                            scrollController: scrollController,
                            data: state.data,
                            onCancelButtonTapped: () async {
                              await _pc.close();
                              _bloc(context).add(OnCloseDetailedSlider());
                            },
                          );
                        } else if (state is BuildingRouteState) {
                          return _LoadingRouteSelectSliderState(
                            scrollController: scrollController,
                          );
                        } else if (state is RouteSelectSliderState) {
                          return _RouteSelectSliderState(
                            onSelectRouteType: () async {
                              await _pc.close();
                            },
                            scrollController: scrollController,
                            data: state.data,
                            routeType: state.routeType,
                          );
                        } else {
                          return _GeneralSlider(
                            scrollController: scrollController,
                            onTapObject: () async {
                              await _pc.close();
                            },
                          );
                        }
                      },
                      borderRadius: _borderRadius,
                      onPanelSlide: _onPanelSlide,
                    );
                  },
                ),
                BlocBuilder<PlanDetailsBloc, PlanDetailsState>(
                  builder: (context, state) {
                    bool isGeneral = false;
                    if (state is DetailedSliderState) {
                      isGeneral = false;
                    } else if (state is RouteSelectSliderState) {
                      isGeneral = false;
                    } else if (state is BuildingRouteState) {
                      isGeneral = false;
                    } else {
                      isGeneral = true;
                    }
                    return Positioned(
                      top: 20,
                      left: 16,
                      child: Opacity(
                        opacity: _opacity(
                          x: _fabPos,
                          ratio: 0.9,
                          isGeneral: isGeneral,
                        ),
                        child: _BackButton(
                          onTap: () {
                            if (state is RouteSelectSliderState) {
                              _bloc(context).add(OnCloseRouteSlider());
                            } else if (state is DetailedSliderState) {
                              _bloc(context).add(OnCloseDetailedSlider());
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
                BlocBuilder<PlanDetailsBloc, PlanDetailsState>(
                  builder: (context, state) {
                    bool isGeneral = false;
                    if (state is DetailedSliderState) {
                      isGeneral = false;
                    } else if (state is RouteSelectSliderState) {
                      isGeneral = false;
                    } else if (state is BuildingRouteState) {
                      isGeneral = false;
                    } else {
                      isGeneral = true;
                    }
                    return Positioned(
                      top: 20,
                      right: 16,
                      child: Opacity(
                        opacity: _opacity(
                          x: _fabPos,
                          ratio: 0.9,
                          isGeneral: isGeneral,
                        ),
                        child: _SearchButton(
                          onTap: () {
                            print('Make Search');
                          },
                        ),
                      ),
                    );
                  },
                ),
                BlocBuilder<PlanDetailsBloc, PlanDetailsState>(
                  builder: (context, state) {
                    double _initFab;
                    double _panelHeightOpen;
                    double _panelHeightClosed;
                    bool isGeneral = false;
                    if (state is DetailedSliderState) {
                      _initFab = _initFabHeightDetailed;
                      _panelHeightOpen = _panelHeightOpenDetailed;
                      _panelHeightClosed = _panelHeightClosedDetailed;
                      isGeneral = false;
                    } else if (state is RouteSelectSliderState) {
                      _initFab = _initFabHeightRoute;
                      _panelHeightOpen =
                      state.routeType == RouteTypes.masstransit
                      ? _panelHeightOpenRoute
                      : _panelHeightClosedRoute;
                      _panelHeightClosed = _panelHeightClosedRoute;
                      isGeneral = false;
                    } else if (state is BuildingRouteState) {
                      _initFab = _initFabHeightRoute;
                      _panelHeightOpen = _panelHeightClosedRoute;
                      _panelHeightClosed = _panelHeightClosedRoute;
                      isGeneral = false;
                    } else {
                      _initFab = _initFabHeightGeneral;
                      _panelHeightOpen = _panelHeightOpenGeneral;
                      _panelHeightClosed = _panelHeightClosedGeneral;
                      isGeneral = true;
                    }
                    return Positioned(
                      bottom: posButtonsTopCalculatingFunction(
                        x: _fabPos,
                        initFabHeight: _initFab,
                        panelHeightOpen: _panelHeightOpen,
                        panelHeightClosed: _panelHeightClosed,
                      ),
                      right: 16,
                      child: Opacity(
                        opacity: _opacity(
                          x: _fabPos,
                          isGeneral: isGeneral,
                        ),
                        child: _LocationButton(
                          onTap: () {
                            print('Go to my location');
                            _bloc(context).add(OnShowMyLocation());
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class _LoadingRouteSelectSliderState extends StatelessWidget {
  final ScrollController scrollController;
  final bool isLoading;
  final Spot data;

  const _LoadingRouteSelectSliderState({
    Key key,
    this.scrollController,
    this.isLoading,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _GrayMark(),
          Expanded(
            child: Container(
              constraints: BoxConstraints.expand(),
              alignment: Alignment.center,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteSelectSliderState extends StatefulWidget {
  final ScrollController scrollController;
  final Spot data;
  final RouteTypes routeType;
  final void Function() onSelectRouteType;

  _RouteSelectSliderState({
    Key key,
    this.scrollController,
    this.data,
    this.routeType,
    this.onSelectRouteType,
  }) : super(key: key);

  @override
  __RouteSelectSliderStateState createState() =>
      __RouteSelectSliderStateState();
}

class __RouteSelectSliderStateState extends State<_RouteSelectSliderState> {
  ScrollController scroll = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      double moveTo = 0;
      if (widget.routeType == RouteTypes.masstransit) {
        moveTo = 0;
      }
      if (widget.routeType == RouteTypes.pedestrian) {
        moveTo = scroll.position.maxScrollExtent / 4;
      }
      if (widget.routeType == RouteTypes.bicycle) {
        moveTo = scroll.position.maxScrollExtent / 3;
      }
      if (widget.routeType == RouteTypes.driving) {
        moveTo = scroll.position.maxScrollExtent;
      }
      scroll.animateTo(
        moveTo,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _GrayMark(),
              _HeaderRoute(data: widget.data),
            ],
          ),
        ),
        BlocBuilder<PlanDetailsBloc, PlanDetailsState>(
          builder: (context, state) {
            if (state is RouteSelectSliderState) {
              return Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: 60,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: ListView(
                              children: [
                                SizedBox(width: 8),
                                _TransportFilterChip(
                                  isActive:
                                  state.routeType == RouteTypes.masstransit,
                                  icon: 'images/bus.png',
                                  iconActive: 'images/bus_active.png',
                                  time: state.time[RouteTypes.masstransit],
                                  onPressed: () async {
                                    _bloc(context).add(OnBuildRoute());
                                    widget.onSelectRouteType();
                                  },
                                ),
                                _TransportFilterChip(
                                  isActive:
                                  state.routeType == RouteTypes.pedestrian,
                                  icon: 'images/walk.png',
                                  iconActive: 'images/walk_active.png',
                                  time: state.time[RouteTypes.pedestrian],
                                  onPressed: () {
                                    _bloc(context).add(
                                      OnBuildRoute(
                                          routeType: RouteTypes.pedestrian),
                                    );
                                    widget.onSelectRouteType();
                                  },
                                ),
                                _TransportFilterChip(
                                  isActive:
                                  state.routeType == RouteTypes.bicycle,
                                  icon: 'images/bike.png',
                                  iconActive: 'images/bike_active.png',
                                  time: state.time[RouteTypes.bicycle],
                                  onPressed: () {
                                    _bloc(context).add(
                                      OnBuildRoute(
                                          routeType: RouteTypes.bicycle),
                                    );
                                    widget.onSelectRouteType();
                                  },
                                ),
                                _TransportFilterChip(
                                  isActive:
                                  state.routeType == RouteTypes.driving,
                                  icon: 'images/auto.png',
                                  iconActive: 'images/auto_active.png',
                                  time: state.time[RouteTypes.driving],
                                  onPressed: () {
                                    _bloc(context).add(
                                      OnBuildRoute(
                                          routeType: RouteTypes.driving),
                                    );
                                    widget.onSelectRouteType();
                                  },
                                ),
                                SizedBox(width: 8),
                              ],
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              controller: scroll,
                              addAutomaticKeepAlives: true,
                              addSemanticIndexes: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        controller: widget.scrollController,
                        physics: BouncingScrollPhysics(),
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: state.routeInfo != null
                                   ? RoutePathDetailsHeader(state.routeInfo)
                                   : SizedBox.shrink(),
                          ),
                          Container(
                            child: state.routeInfo != null
                                   ? RoutePathDetails(state.routeInfo)
                                   : Container(),
                          ),
                        ],
                        shrinkWrap: true,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}

class _TransportFilterChip extends StatelessWidget {
  final bool isActive;
  final String icon;
  final String iconActive;
  final String time;
  final VoidCallback onPressed;

  const _TransportFilterChip({
    Key key,
    @required this.isActive,
    @required this.icon,
    @required this.iconActive,
    @required this.time,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryRed : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 1,
          color: isActive ? AppColors.darkGray : AppColors.lightGray,
        ),
      ),
      child: Material(
        color: isActive ? AppColors.darkGray : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          highlightColor: isActive ? Colors.white24 : null,
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child:
                    isActive ? Image.asset(iconActive) : Image.asset(icon)),
                Text(
                  time,
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderRoute extends StatelessWidget {
  final Spot data;

  const _HeaderRoute({
    Key key,
    @required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Text(
                  'Откуда: Мое местоположение',
                  style: GolosTextStyles.mainTextSize16(
                    golosTextColors: GolosTextColors.grayDark,
                  ),
                ),
              ),
              _CancelButton(
                onPressed: () {
                  _bloc(context).add(OnCloseRouteSlider());
                },
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Text(
                  'Куда: ' + data.title.localize(context),
                  style: GolosTextStyles.h3size16(
                    golosTextColors: GolosTextColors.grayDarkVery,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailedSlider extends StatelessWidget {
  final ScrollController scrollController;
  final Function onCancelButtonTapped;
  final Spot data;

  const _DetailedSlider({
    Key key,
    this.scrollController,
    this.onCancelButtonTapped,
    this.data,
  })  : assert(data != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _HeaderDetailed(onCancelButtonTapped: onCancelButtonTapped),
        Expanded(
          child: ListView(
            controller: scrollController,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _GeoObjectImage(
                      image: ImageEither.url(
                        data.thumbnail.url,
                      ),
                    ),
                    _Address(data?.address?.localize(context) ?? 'Sample'),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: GestureDetector(
                        onTap: () {

                          if (data.type == ActivityType.event) {
                            Navigator.of(context)
                                .push(Ev.EventDetailPage.route(data.ref));
                          } else if (data.type == ActivityType.restaurant) {
                            Navigator.of(context)
                                .push(Re.RestaurantDetailPage.route(data.ref));
                          }

//                          if (data.type == ActivityType.event) {} else
//                          if (data.type == ActivityType.restaurant) {}

                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Color(0xFFF2F2F2),
                                child:
                                Icon(Icons.receipt, color: AppColors.gray),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Подробнее',
                                style: TextStyle(
                                  color: AppColors.darkGray,
                                  fontWeight: NamedFontWeight.semiBold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.lightGray,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GeneralSlider extends StatelessWidget {
  final ScrollController scrollController;
  final void Function() onTapObject;

  const _GeneralSlider({Key key, this.scrollController, this.onTapObject})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _GrayMark(),
              _Header(),
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 8,
                color: AppColors.backgroundGray,
              ),
            ],
          ),
        ),
        BlocBuilder<PlanDetailsBloc, PlanDetailsState>(
          builder: (context, state) {
            if (state is InitialLoadingDetailsState ||
                state is LoadingDetailsState) {
              return Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return _Body(
                scrollController: scrollController,
                onTapObject: onTapObject,
              );
            }
          },
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final ScrollController scrollController;
  final void Function() onTapObject;

  const _Body({Key key, this.scrollController, this.onTapObject})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: ListView(
          controller: scrollController,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: <Widget>[
//            Container(
//              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//              child: Row(
//                children: <Widget>[
//                  Expanded(
//                    child: Text(
//                      Добавить к поездке,
//                      style: TextStyle(
//                        fontSize: 14,
//                        fontWeight: NamedFontWeight.bold,
//                        color: AppColors.darkGray,
//                      ),
//                    ),
//                  ),
//                  _PlusButton(
//                    onPressed: () {},
//                  ),
//                ],
//              ),
//            ),
//            Container(
//              margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
//              height: 0.5,
//              color: Colors.black26,
//            ),
            _TripInformation(),
            Container(
              padding: EdgeInsets.only(left: 16, top: 8, bottom: 4),
              alignment: Alignment.centerLeft,
              child: BlocBuilder<PlanDetailsBloc, PlanDetailsState>(
                builder: (context, state) {
                  if (state is LoadedState) {
                    return Text(
                      state.details.body.spotsHint.localize(context),
                      style: GolosTextStyles.additionalSize14(
                        golosTextColors: GolosTextColors.grayDark,
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ),
            BlocBuilder<PlanDetailsBloc, PlanDetailsState>(
              builder: (context, state) {
                if (state is LoadedState) {
                  return ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    children: state.details.body.spots
                        .map(
                          (it) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _BottomSliderSheetCard(
                              data: it,
                              onTap: onTapObject,
                            ),
                          ),
                        )
                        .toList(),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),

            BlocBuilder<PlanDetailsBloc, PlanDetailsState>(
              builder: (context, state) {
                if (state is LoadedState) {
                  return ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    children: [
                      if (state.details.body.spotsNoDate.length > 0)
                        Container(
                          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                          child: Text(
                            'Не распределено по дням:',
                            style: GolosTextStyles.additionalSize14(
                              golosTextColors: GolosTextColors.grayDark,
                            ),
                          ),
                        ),
                      ...state.details.body.spotsNoDate
                          .map(
                            (it) =>
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                              child: _BottomSliderSheetCard(
                                data: it,
                                onTap: onTapObject,
                              ),
                            ),
                      )
                          .toList()
                    ],
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TripInformation extends StatelessWidget {
  const _TripInformation({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanDetailsBloc, PlanDetailsState>(
      builder: (context, state) {
        if (state is LoadedState && state.details.body.tickets.length > 0) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 8),
                  padding: EdgeInsets.only(left: 16),
                  constraints: BoxConstraints.expand(height: 96),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: state.details.body.tickets
                        .map((it) => GeneralTripInfo(data: it))
                        .toList(),
                  ),
                ),
              ),
            ],
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}

class GeneralTripInfo extends StatelessWidget {
  final Ticket data;

  const GeneralTripInfo({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      width: 285,
      margin: EdgeInsets.only(right: 16),
      child: Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 2,
                color: AppColors.primaryRed,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.backgroundGray,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          data.title.localize(context),
                          style: GolosTextStyles.h3size16(
                            golosTextColors: GolosTextColors.grayDarkVery,
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              data.date.localize(context),
                              style: GolosTextStyles.additionalSize14(
                                golosTextColors: GolosTextColors.grayDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          ClipPath(
            clipper: CircleClip(),
            clipBehavior: Clip.antiAlias,
            child: Container(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class CircleClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addOval(Rect.fromCircle(
      center: Offset(size.width, size.height / 2),
      radius: 8,
    ));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class _BottomSliderSheetCard extends StatelessWidget {
  final Spot data;
  final void Function() onTap;

  const _BottomSliderSheetCard({Key key, this.data, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const imageSide = 80.0;

    return GestureDetector(
      onTap: () async {
        onTap();
        print('onTap ${data.title} ${data.ref}');
        _bloc(context).add(OnSelectPlace(data.ref));
      },
      child: Container(
        margin: EdgeInsets.only(top: 16),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: imageSide,
                  width: imageSide,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    image: DecorationImage(
                      image: data.thumbnail.match(
                        (asset) => AssetImage(asset),
                        (url) => CachedNetworkImageProvider(url),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        data.title.localize(context),
                        style: GolosTextStyles.h3size16(
                          golosTextColors: GolosTextColors.grayDarkVery,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        data.hint.localize(context),
                        style: GolosTextStyles.additionalSize14(
                          golosTextColors: GolosTextColors.grayDark,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(
                    Icons.more_horiz,
                    color: Colors.black38,
                  ),
                  onPressed: () {
                    showItemDialog(context, data);
                  },
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Divider(
              height: 0,
              color: Colors.black26,
            ),
          ],
        ),
      ),
    );
  }

  Future showItemDialog(context, Spot data) {
    return showDialog(
      context: context,
      child: BlocProvider.value(
        value: _bloc(context),
        child: Builder(
          builder: (context) =>
              AppChooserDialog(
                options: [
                  AppDialogOption(
                    title: 'Выбрать дату',
                    onTap: () async {
                      print('add date');
                      PlanDetailsBloc b = _bloc(context);
                      Navigator.pop(context);
                      DateTime date = await showRussPassDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().add(Duration(days: -500)),
                        lastDate: DateTime.now().add(Duration(days: 500)),
                        initialDatePickerMode: DatePickerMode.day,
                        locale: Locale('ru'),
                        dayTextStyle: GolosTextStyles.h3size16(
                            golosTextColors: GolosTextColors.grayDarkVery)
                            .copyWith(height: 1.5),
                        yearTextStyle: GolosTextStyles.h2size20(
                            golosTextColors: GolosTextColors.grayDarkVery)
                            .copyWith(height: 1.7),
                        backgroundColor: Colors.white,
                        saveText: "Выбрать",
                        cancelText: 'Отменить',
                        monthTextStyle: GolosTextStyles.mainTextSize16(
                            golosTextColors: GolosTextColors.grayDarkVery),
                      );
                      if (date != null) {
                        b.add(OnAssignActivityDate(data, date));
                      }
                    },
                  ),
                  AppDialogOption(
                    title: 'Удалить',
                    onTap: () {
                      print('delete');
                      Navigator.of(context).pop();
                      showDeleteDialog(
                        context: context,
                        title: 'Удалить активность',
                        text: 'Если удалить эту активность, она будет исключена '
                            'из вашего плана поездки.',
                      );
                    },
                  ),
                ],
              ),
        ),
      ),
    );
  }

  Future showDeleteDialog({
    @required BuildContext context,
    @required String title,
    @required String text,
  }) {
    return showDialog(
      context: context,
      child: BlocProvider.value(
        value: _bloc(context),
        child: Builder(
          builder: (context) {
            return YesNoDialog(
              title: title,
              text: text,
              cancelOption: 'Отменить',
              okOption: 'Удалить',
              onSuccess: () {
                _bloc(context).add(OnDeleteActivity(data.ref));
              },
            );
          },
        ),
      ),
    );
  }
}

class _PlanActionsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppChooserDialog(
      options: [
        AppDialogOption(
          title: 'Изменить название',
          onTap: () {
            Navigator.of(context).pop();
            _bloc(context).add(OnClickUpdatePlanName());
          },
        ),
        AppDialogOption(
          title: 'Редактировать план',
          onTap: () {},
        ),
        AppDialogOption(
          title: 'Поделиться',
          onTap: () {},
        ),
        AppDialogOption(
          title: 'Удалить план',
          onTap: () {
            Navigator.of(context).pop();
            showDialog(
              context: context,
              child: BlocProvider.value(
                value: _bloc(context),
                child: Builder(
                  builder: (context) {
                    return YesNoDialog(
                      title: 'Удалить план',
                      text: 'Вы уверены, что хотите удалить план?',
                      cancelOption: 'Отменить',
                      okOption: 'Удалить',
                      onSuccess: () {
                        _bloc(context).add(OnDeletePlan());
                      },
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class BottomSliderSheetData {
  final String title;
  final String subtitle;
  final String urlPic;

  BottomSliderSheetData({this.title, this.subtitle, this.urlPic});
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _HeaderTitle(),
          _HeaderSubTitle(),
          SizedBox(height: 8),
          _HeaderDates(),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanDetailsBloc, PlanDetailsState>(
        builder: (context, state) {
      if (state is LoadedState) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                state.details.header.title.localize(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: NamedFontWeight.bold,
                  color: AppColors.darkGray,
                ),
              ),
            ),
            IconButton(
              padding: EdgeInsets.all(0),
              icon: Icon(
                Icons.more_horiz,
                color: Colors.black,
              ),
              onPressed: () {
//                showModalBottomSheet(
//                  context: context,
//                  backgroundColor: Colors.transparent,
//                  isDismissible: true,
//                  builder: (context) {
//                    return _PlanActionsDialog();
//                  },
//                );
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  child: BlocProvider.value(
                    value: _bloc(context),
                    child: _PlanActionsDialog(),
                  ),
                );
              },
            ),
          ],
        );
      } else {
        return SizedBox(
          height: 48,
          width: double.infinity,
          child: Text(
            '...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: NamedFontWeight.bold,
              color: AppColors.darkGray,
            ),
          ),
        );
      }
    });
  }
}

class _HeaderSubTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanDetailsBloc, PlanDetailsState>(
      builder: (context, state) {
        if (state is LoadedState) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                state.details.header.fromDate.localize(context),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: NamedFontWeight.regular,
                  color: AppColors.mediumGray,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  Icons.arrow_forward,
                  color: AppColors.mediumGray,
                  size: 16,
                ),
              ),
              Text(
                state.details.header.toDate.localize(context),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: NamedFontWeight.regular,
                  color: AppColors.mediumGray,
                ),
              ),
            ],
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}

class _HeaderDates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanDetailsBloc, PlanDetailsState>(
      builder: (context, state) {
        if (state is LoadedState) {
          final header = state.details.header;

          if (header.dates.isEmpty) {
            return SizedBox.shrink();
          } else {
            return Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: <Widget>[
                        _DateCard(
                          data: Optional.empty(),
                          isPressed: !header.selectedDateRef.isPresent,
                        ),
                        ...header.dates.map(
                          (it) => _DateCard(
                            data: Optional.of(it),
                            isPressed:
                            header.selectedDateRef.orElse('') == it.ref,
                          ),
                        ),
                      ],
                    ),
                    constraints: BoxConstraints.expand(height: 56),
                  ),
                ),
              ],
            );
          }
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}

class DateCardData {
  final DateTime date;
  final String weekDay;
  final bool isAllDateCard;

  DateCardData({
    this.date,
    this.weekDay,
    this.isAllDateCard = false,
  });
}

class _PlusButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _PlusButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: 24.0,
          width: 24.0,
          child: IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(
              Icons.add_circle,
              color: AppColors.primaryRed,
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}

class _DateCard extends StatelessWidget {
  final Optional<PlanDate> data;
  final bool isPressed;

  const _DateCard({
    Key key,
    @required this.data,
    @required this.isPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanDetailsBloc, PlanDetailsState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: state is! LoadingDetailsState
              ? () {
                  if (data.isPresent) {
                    _bloc(context).add(OnSelectDate(data.value.ref));
                  } else {
                    _bloc(context).add(OnSelectAllDates());
                  }
                }
              : null,
          child: Opacity(
            opacity: (state is LoadingDetailsState && !isPressed) ? 0.5 : 1.0,
            child: Container(
              width: 56,
              margin: EdgeInsets.only(right: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:
                isPressed ? AppColors.primaryRed : AppColors.backgroundGray,
                borderRadius: BorderRadius.circular(8),
              ),
              child: !data.isPresent
                  ? Icon(
                      Icons.format_list_bulleted,
                color:
                isPressed ? Colors.white : GolosTextColors.grayDark,
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          data.value.weekDayShort.localize(context),
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: GolosTextStyles.fontFamily,
                            color: isPressed
                                   ? Colors.white
                                   : GolosTextColors.grayDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          data.value.day.toString(),
                          style: GolosTextStyles.h3size16(
                              golosTextColors: isPressed
                                               ? Colors.white
                                               : GolosTextColors.grayDarkVery),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _GrayMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      height: 4,
      width: 32,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final Function onTap;

  const _BackButton({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ButtonBaseForMap(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: 2),
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _SearchButton extends StatelessWidget {
  final Function onTap;

  const _SearchButton({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ButtonBaseForMap(
      onTap: onTap,
      child: Icon(
        Icons.search,
        color: Colors.black,
        size: 26,
      ),
    );
  }
}

class _ZoomButtons extends StatelessWidget {
  final Function onTapZoomIn;
  final Function onTapZoomOut;

  const _ZoomButtons({Key key, this.onTapZoomIn, this.onTapZoomOut})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _ButtonBaseForMap(
          onTap: onTapZoomIn,
          child: Icon(
            Icons.add,
            color: Colors.black,
            size: 30,
          ),
        ),
        SizedBox(height: 4),
        _ButtonBaseForMap(
          onTap: onTapZoomOut,
          child: Icon(
            Icons.remove,
            color: Colors.black,
            size: 30,
          ),
        ),
      ],
    );
  }
}

class _LocationButton extends StatelessWidget {
  final Function onTap;

  const _LocationButton({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ButtonBaseForMap(
      onTap: onTap,
      child: Icon(
        Icons.near_me,
        color: Colors.black,
        size: 20,
      ),
    );
  }
}

class _ButtonBaseForMap extends StatelessWidget {
  final Widget child;
  final Function onTap;

  const _ButtonBaseForMap({Key key, @required this.child, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: Colors.white,
      onPressed: onTap,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      mini: true,
      child: child,
    );
  }
}

class _UpdatePlanBottomSheetContent extends SingleTextInputBottomSheetContent<
    PlanDetailsBloc,
    PlanDetailsState> {
  @override
  bool isLoadingState(PlanDetailsState state) => state is UpdatingPlanNameState;

  @override
  bool isFinishState(PlanDetailsState state) => state is UpdatedPlanNameState;

  @override
  PlanDetailsBloc bloc(BuildContext context) => _bloc(context);

  @override
  String title(BuildContext context) {
    return 'Изменить имя плана';
  }

  @override
  void onSubmit(BuildContext context, String name) {
    _bloc(context).add(OnUpdatePlanNameSubmit(name));
  }
}

class _Address extends StatelessWidget {
  final String address;

  const _Address(this.address, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Адрес',
                  style: TextStyle(
                    fontWeight: NamedFontWeight.semiBold,
                    fontSize: 14,
                    color: Colors.grey.withOpacity(0.6),
                  ),
                ),
                Text(
                  address,
                  style: TextStyle(
                    fontWeight: NamedFontWeight.regular,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GeoObjectImage extends StatelessWidget {
  final ImageEither image;

  const _GeoObjectImage({
    Key key,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 168,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Color(0xFFD8D8D8),
              image: DecorationImage(
//                  image: AssetImage(imageUrl), fit: BoxFit.cover),
                fit: BoxFit.cover,
                image: image.match(
                  (asset) => AssetImage(asset),
                  (url) => CachedNetworkImageProvider(url),
                ),
              ),
            ),
// TODO(Andrey): uncomment
//      child: CachedNetworkImage(
//        imageUrl: imageUrl,
//        placeholder: (context, url) => SizedBox(
//          height: 168,
//          child: Center(child: CircularProgressIndicator()),
//        ),
//        errorWidget: (context, url, error) => Icon(Icons.error),
//        imageBuilder: (context, imageProvider) => Container(
//          height: 168,
//          decoration: BoxDecoration(
//            image: DecorationImage(
//              image: imageProvider,
//              fit: BoxFit.cover,
//            ),
//          ),
//        ),
//      ),
          ),
        ],
      ),
    );
  }
}

class _HeaderDetailed extends StatelessWidget {
  final Function onCancelButtonTapped;

  const _HeaderDetailed({Key key, this.onCancelButtonTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanDetailsBloc, PlanDetailsState>(
      builder: (BuildContext context, PlanDetailsState state) {
        if (state is DetailedSliderState) {
          return Container(
            height: 190,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _GrayMark(),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 8, 10, 12),
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                state.data.title.localize(context),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: NamedFontWeight.bold,
                                  color: AppColors.darkGray,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 6),
                              Text(
                                state.data.hint.localize(context),
                                style: TextStyle(
                                  fontWeight: NamedFontWeight.regular,
                                  fontSize: 14,
                                  color: AppColors.darkGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          _CancelButton(onPressed: onCancelButtonTapped),
                          SizedBox(height: 4),
                          Text(
                            '~2.3 км',
                            style: TextStyle(
                              fontWeight: NamedFontWeight.semiBold,
                              fontSize: 14,
                              color: Colors.grey.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(14),
                  color: Colors.white,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: _RoutesButton(
                          onPressed: () {
                            _bloc(context).add(OnBuildRoute());
                          },
                        ),
                      ),
                      Expanded(
                        child: _TaxiButton(
                          lat: state?.destPoint?.latitude,
                          lon: state?.destPoint?.longitude,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}

class _TaxiButton extends StatefulWidget {
  final VoidCallback onPressed;
  final double lat;
  final double lon;

  const _TaxiButton({Key key, this.onPressed, this.lat, this.lon})
      : super(key: key);

  @override
  _TaxiButtonState createState() => _TaxiButtonState();
}

class _TaxiButtonState extends State<_TaxiButton> {
  bool _isPressed = false;
  double lat;
  double lon;

  buttonStyle(pressed) => ParentStyle()
    ..background.color(AppColors.backgroundGray)
    ..alignmentContent.center()
    ..borderRadius(all: 4)
    ..height(42)
    ..margin(left: 6, right: 6)
    ..padding(left: 8, right: 8)
    ..ripple(true)
//    ..elevation(pressed ? 6 : 2)
    ..animate(150, Curves.easeOut);

  _launchTaxiUrl() async {
    double latitude = widget.lat;
    double longitude = widget.lon;
    bool installedTaxi;
    String androidTaxi = "ru.yandex.taxi";
//    String iosTaxi = "yandextaxi://";
    if (Platform.isAndroid) {
      try {
        installedTaxi = await AppAvailability.isAppEnabled(androidTaxi);
      } catch (_) {
        installedTaxi = false;
      }
      if (installedTaxi) {
        final AndroidIntent intent = AndroidIntent(
            action: 'action_view',
            data: Uri.encodeFull('geo:$latitude,$longitude'),
            package: androidTaxi);
        await intent.launch();
      } else {
        OpenAppstore.launch(androidAppId: androidTaxi);
      }
    } else if (Platform.isIOS) {
      final yandexTaxiAppId = '472650686';
      try {
        launchURL(latitude, longitude);
      } on Exception catch (_) {
        OpenAppstore.launch(
            androidAppId: androidTaxi, iOSAppId: yandexTaxiAppId);
      }
    }
  }

  launchURL(double endLat, double endLon) async {
    try {
      String url =
          'yandextaxi://route?end-lat=$endLat&end-lon=$endLon&appmetrica_tracking_id=1178268795219780156';
      await launch(url);
    } catch (e) {
      print(e);
    }
  }

  GestureClass buttonGestures() => GestureClass()
    ..isTap((isPressed) => setState(() => _isPressed = isPressed))
    ..onTap(_launchTaxiUrl);

  @override
  Widget build(BuildContext context) {
    return Parent(
      style: buttonStyle(_isPressed),
      gesture: buttonGestures(),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: SizedBox(
              height: 30,
              child: Image.asset('images/mock_images/yandex_taxi.png'),
            ),
          ),
          Text(
            'Вызвать такси',
            style: TextStyle(fontSize: 14, color: AppColors.darkGray),
          ),
        ],
      ),
    );
  }
}

class _RoutesButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _RoutesButton({Key key, this.onPressed}) : super(key: key);

  @override
  _RoutesButtonState createState() => _RoutesButtonState();
}

class _RoutesButtonState extends State<_RoutesButton> {
  bool _isPressed = false;

  buttonStyle(pressed) => ParentStyle()
    ..background.color(AppColors.primaryRed)
    ..alignmentContent.center()
    ..borderRadius(all: 4)
    ..height(42)
    ..margin(left: 6, right: 6)
    ..padding(left: 8, right: 8)
    ..ripple(true)
//    ..elevation(pressed ? 6 : 2)
    ..animate(150, Curves.easeOut);

  GestureClass buttonGestures() => GestureClass()
    ..isTap((isPressed) => setState(() => _isPressed = isPressed))
    ..onTap(widget.onPressed);

  @override
  Widget build(BuildContext context) {
    return Parent(
      style: buttonStyle(_isPressed),
      gesture: buttonGestures(),
      child: Text(
        'Маршрут',
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CancelButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: 24.0,
          width: 24.0,
          child: IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(Icons.cancel, color: Colors.grey.withOpacity(0.6)),
            onPressed: () {
              if (onPressed != null) {
                onPressed();
              }
            },
          ),
        ),
      ),
    );
  }
}
