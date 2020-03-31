import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:division/division.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rp_mobile/containers/image.dart';
import 'package:rp_mobile/layers/bloc/routes/bloc.dart';
import 'package:rp_mobile/layers/bloc/routes/routes_models.dart';
import 'package:rp_mobile/layers/services/geo_objects.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/pages/routes/path_details.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/widgets/base/bottom_nav_bar.dart';
import 'package:rp_mobile/layers/ui/widgets/base/divider.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:android_intent/android_intent.dart';
import 'dart:io';

class RoutesPageProvider extends StatelessWidget {
  final String ref;

  const RoutesPageProvider(this.ref, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RoutesBloc>(
      create: (context) {
        return RoutesBloc(GetIt.instance<GeoObjectsService>())..add(OnLoad());
      },
      child: RoutesPage(),
    );
  }
}

RoutesBloc _bloc(BuildContext context) => BlocProvider.of<RoutesBloc>(context);

class RoutesPage extends StatefulWidget {
  static route([String ref]) =>
      MaterialPageRoute(builder: (context) => RoutesPageProvider(ref));

  @override
  _RoutesPageState createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  static SheetState sheetState;

  static bool get isExpanded => sheetState?.isExpanded ?? false;

  static bool get isCollapsed => sheetState?.isCollapsed ?? true;

  static bool get isShown => sheetState?.isShown ?? true;
  static final sheetController = SheetController();
  static bool sheetUpdate = false;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bottomNavigationBar: BottomNavBar(index: BottomNavPageIndex.map),
      safeAreaTop: false,
      theme: AppThemes.routesAppTheme(),
      body: Stack(
        children: <Widget>[
/*
          Positioned.fill(
            child: Column(
              children: <Widget>[
                Expanded(child: _Map()),
              ],
            ),
          ),
          BlocBuilder<RoutesBloc, RoutesState>(
            builder: (context, state) {
              if (state is RouteToGeoObjectState) {
                return _SelectTransport();
              }
              if (state is SelectedGeoObjectState ||
                  state is SelectGeoObjectLoadingState) {
                      return _GeoObjectInfo(isOpen: true);
              } else {
                return _GeoObjectInfo(isOpen: false);
              }
            },
          ),
          BlocBuilder<RoutesBloc, RoutesState>(
              builder: (context, state) {
                if (state is LoadedMapState &&
                    state is! SelectedGeoObjectState &&
                    state is! SelectGeoObjectLoadingState) {
                  return _MapIcon();
                } else {
                  return SizedBox.shrink();
                }
              }
          ),

          BlocBuilder<RoutesBloc, RoutesState>(
            builder: (context, state) {
              if (state is SearchState ||
                  state is SearchLoadingSuggestionsState) {
                return Positioned.fill(
                  child: _SearchAndFilters(
                    isExpanded: true,
                    isOpen: true,
                  ),
                );
              } else if (state is LoadedMapState &&
                  state is! SelectedGeoObjectState &&
                  state is! SelectGeoObjectLoadingState) {
                return Positioned.fill(
                  child: _SearchAndFilters(
                    isExpanded: false,
                    isOpen: true,
                  ),
                );
              } else {
                return Positioned.fill(
                  child: _SearchAndFilters(
                    isExpanded: false,
                    isOpen: false,
                  ),
                );
              }
            },
          ),*/

          Positioned.fill(
            child: Column(
              children: <Widget>[
                Expanded(child: _Map()),
              ],
            ),
          ),
          BlocBuilder<RoutesBloc, RoutesState>(
            builder: (context, state) {
              if (state is LoadedMapState &&
                  state is! SelectedGeoObjectState &&
                  state is! SelectGeoObjectLoadingState) {
                return _MapIcon();
              } else {
                return SizedBox.shrink();
              }
            },
          ),
          BlocBuilder<RoutesBloc, RoutesState>(
            builder: (context, state) {
              if (state is LoadedMapState &&
                  state is! SelectedGeoObjectState &&
                  state is! SelectGeoObjectLoadingState) {
                return buildFiltersSheet();
              }
              if (state is BuildingRouteState ||
                  state is SelectGeoObjectLoadingState) {
                return buildLoader();
              }
              if (state is RouteToGeoObjectState) {
                return buildSelectTransport();
              }
              if (state is SelectedGeoObjectState) {
                return buildGeoObjectInfo();
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildLoader() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
//                color: Colors.white,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 5.0, // soften the shadow
              spreadRadius: 5.0, //extend the shadow
              offset: Offset(
                0,
                5.0,
              ),
            )
          ],
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSelectTransport() {
    return BlocBuilder<RoutesBloc, RoutesState>(
      builder: (context, state) {
        if (state is RouteToGeoObjectState) {
          return SlidingSheet(
            controller: sheetController,
            elevation: 6,
            cornerRadius: 8,
            snapSpec: SnapSpec(
              snap: true,
              snappings: [
                SnapSpec.headerFooterSnap,
                0.8,
              ],
              positioning: SnapPositioning.relativeToAvailableSpace,
            ),
            headerBuilder: (contexts, states) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    state.info != null ? _TapMark() : SizedBox.shrink(),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 8, 10, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Откуда: мое местоположение',
                                    style: TextStyle(
                                      fontWeight: NamedFontWeight.regular,
                                      fontSize: 14,
                                      color: AppColors.gray,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Куда: ' + state.details.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: NamedFontWeight.bold,
                                      color: AppColors.darkGray,
                                    ),
                                  ),
                                  state.info != null
                                      ? RoutePathDetailsHeader(state.info)
                                      : SizedBox.shrink(),
                                ],
                              ),
                            ),
                          ),
                          _CancelButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            footerBuilder: (contexts, states) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: _TransportFilters(),
              );
            },
            builder: (contexts, states) {
              return Container(
//                    height: 200,
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    state.info != null
                        ? RoutePathDetails(state.info)
                        : Container(
                      height: 1,
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget buildGeoObjectInfo() {
    return BlocBuilder<RoutesBloc, RoutesState>(
      builder: (context, state) {
        if (state is SelectedGeoObjectState) {
          return SlidingSheet(
            controller: sheetController,
            elevation: 6,
            cornerRadius: 8,
            snapSpec: SnapSpec(
              snap: true,
              snappings: [
                SnapSpec.headerSnap,
                0.8,
              ],
              positioning: SnapPositioning.relativeToAvailableSpace,
            ),
            headerBuilder: (contexts, states) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _TapMark(),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 8, 10, 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(8),
                          topRight: const Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    state.details.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: NamedFontWeight.bold,
                                      color: AppColors.darkGray,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    state.details.openUntil,
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
                              _CancelButton(),
                              SizedBox(height: 4),
                              Text(
                                state.details.distance.isPresent
                                    ? state.details.distance.value
                                    : '',
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
                                lat: state.details.latitude,
                                lon: state.details.longitude),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            builder: (contexts, states) {
              return Container(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    state.details.image.isPresent
                        ? _QrCode()
                        : SizedBox.shrink(),
                    state.details.image.isPresent
                        ? _GeoObjectImage(
                      image: state.details.image.value,
                    )
                        : SizedBox.shrink(),
                    _Address(
                      state.details,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: GestureDetector(
                        onTap: () {},
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
                                )),
                            Icon(Icons.arrow_forward_ios,
                                color: AppColors.lightGray)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget buildFiltersSheet() {
    return SlidingSheet(
      elevation: 6,
      cornerRadius: 8,
      snapSpec: const SnapSpec(
        snap: true,
        snappings: [
          0.1,
        ],
        positioning: SnapPositioning.relativeToAvailableSpace,
      ),
      builder: (context, state) {
        return Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _Filters(),
                    ),
                    _Divider(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
/*

class _GeoObjectInfo extends StatefulWidget {
  final bool isOpen;

  const _GeoObjectInfo({
    Key key,
    this.isOpen = false,
  }) : super(key: key);

  @override
  _GeoObjectInfoState createState() => _GeoObjectInfoState();
}

class _GeoObjectInfoState extends State<_GeoObjectInfo>
    with TickerProviderStateMixin {
  AnimationController _openAnimation;
  AnimationController _expandedAnimation;

  @override
  void initState() {
    super.initState();

    _openAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: widget.isOpen ? 1.0 : 0.0,
    );

    _expandedAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 0.0,
    );
  }

  @override
  void dispose() {
    _openAnimation.dispose();
    _expandedAnimation.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_GeoObjectInfo oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isOpen) {
      _openAnimation.fling(velocity: 1.0);
    } else {
      _openAnimation.fling(velocity: -1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizeTransition(
        sizeFactor: _openAnimation,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
          ),
          child: BlocBuilder<RoutesBloc, RoutesState>(
            builder: (context, state) {
              if (state is BuildingRouteState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  ],
                );
              } else if (state is SelectGeoObjectLoadingState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  ],
                );
              } else if (state is SelectedGeoObjectState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _Header(state.details, false),
                    Container(
                      padding: const EdgeInsets.all(14),
                      color: Colors.white,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child:
                            _RoutesButton(
                              onPressed: () {
                                _bloc(context).add(OnBuildRoute());
                              },
                            ),
                          ),
                          Expanded(
                            child: _TaxiButton(),
                          ),
                        ],
                      ),
                    ),
//                    _Address(state.details, null),
                  ],
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}
*/

class _Map extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoutesBloc, RoutesState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is LoadedMapState) {
          return _mapToLoadedMapState(context, state);
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget _mapToLoadedMapState(BuildContext context, LoadedMapState state) {
    return YandexMap(
      onGeoObjectTap: (geoObject) {
        debugPrint('LATITUDE: ${geoObject.point.latitude}');
        debugPrint('LONGITUDE: ${geoObject.point.longitude}');
        // TODO: Bloc send event
      },
      onMapCreated: (controller) async {
        _bloc(context).add(OnYandexMapReady(controller));
      },
    );
  }
}

class _TapMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (_) {
        _bloc(context).add(OnCancel());
      },
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: rgba(203, 205, 204, 0.5),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
/*
class _ModalGeoHeader extends StatelessWidget {
  final double topPadding;

  const _ModalGeoHeader({Key key, this.topPadding = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoutesBloc, RoutesState>(
      builder: (context, state) {
        if (state is SelectedGeoObjectState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: topPadding),
              _TapMark(),
              _Header(state.details, true),
            ],
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
*/
/*

class _ModalGeoBody extends StatelessWidget {
  final controller;

  const _ModalGeoBody({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocBuilder<RoutesBloc, RoutesState>(
        builder: (context, state) {
          if (state is SelectedGeoObjectState) {
            return Container(
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
//                          _Address(state.details, controller),
                      Container(
                        padding: const EdgeInsets.all(14),
                        color: Colors.white,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child:
                              _RoutesButton(
                                onPressed: () {
                                  if(controller != null) {
                                    controller.hide();
                                  }
                                  _bloc(context).add(OnBuildRoute());
                                },
                              ),
                            ),
                            Expanded(
                              child: _TaxiButton(),
                            ),
                          ],
                        ),
                      ),
                      state.details.imageUrl.isPresent
                          ? _QrCode()
                          : SizedBox.shrink(),
                      state.details.imageUrl.isPresent
                          ? _GeoObjectImage(
                        imageUrl:
                        state.details.imageUrl.value,
                      )
                          : SizedBox.shrink(),
                      _Address(state.details,
//                              controller
                      ),
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: GestureDetector(
                              onTap: () {},
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child:
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Color(0xFFF2F2F2),
                                      child: Icon(Icons.receipt,
                                          color: AppColors.gray),
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
                                      )),
                                  Icon(Icons.arrow_forward_ios, color: AppColors.lightGray)
                                ],
                              ))),
//                          _YaTaxi(),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
*/
/*

class _Header extends StatelessWidget {
  final GeoObjectDetails details;
//  final SearchSuggestion suggestion;
  final bool icon;

  const _Header(this.details,this.icon, {Key key}) : super(key: key);

  static SheetState sheetState;
  static bool get isCollapsed => sheetState?.isCollapsed ?? true;
  static final dialogController = SheetController();

  @override
  Widget build(BuildContext rootContext) {
//    print (details.distance);
    final mediaQuery = MediaQuery.of(rootContext);
    return GestureDetector(
        onTap: () async {
          bool dismiss = !icon ?
          await showSlidingBottomSheet(
              rootContext,
              builder: (context) {
                return SlidingSheetDialog(
                  controller: dialogController,
                  color: Colors.transparent,
                  //backdropColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  snapSpec: const SnapSpec(
                    snap: true,
                    snappings: [0, 1, 1.0],
                    positioning: SnapPositioning.relativeToAvailableSpace,
                  ),
                  headerBuilder: (context, state) {
                    return BlocProvider.value(
                        value: _bloc(rootContext),
                        child: _ModalGeoHeader(
                          topPadding: mediaQuery.padding.top+80,
                        )
                    );
                  },
                  builder: (context, state) {
                    return BlocProvider.value(
                        value: _bloc(rootContext),
                        child:
                        _ModalGeoBody(controller: dialogController)
                    );
                  },
                );
              }
          ) : true;

          if(dismiss == null && isCollapsed) {
            _bloc(rootContext).add(OnCancel());
          }
        },
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 8, 10, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(8),
                topRight: const Radius.circular(8),
              ),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        */
/* Text(
                          'RUSSPASS',
                          style: TextStyle(
                            fontFamily: 'PT Russia Text',
                            fontSize: 12,
                            fontWeight: NamedFontWeight.semiBold,
                            height: 18 / 12,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                        SizedBox(height: 4),*/ /*

                        Text(
                          details.title,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: NamedFontWeight.bold,
                              color: AppColors.darkGray),
                        ),
                        SizedBox(height: 6),
                        Text(
                          details.openUntil,
                          style: TextStyle(
                              fontWeight: NamedFontWeight.regular,
                              fontSize: 14,
                              color: AppColors.darkGray),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
//                          icon ? Image.asset('images/qr_icon.png') :
                      _CancelButton(
                          onPressed: () {
                            if(dialogController != null) {
                              dialogController.hide();
                            }
                          }

//                                Navigator.of(rootContext).pop(true),
                      ),
                      SizedBox(height: 4),
                      Text(
                        details.distance.isPresent ? details.distance.value : '',
                        style: TextStyle(
                            fontWeight: NamedFontWeight.semiBold,
                            fontSize: 14,
                            color: Colors.grey.withOpacity(0.6)),
                      ),
                    ]
                ),
              ],
            ),
          ),
        ));
  }
}
*/

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
            ]));
  }
}

class _Address extends StatelessWidget {
  final GeoObjectDetails details;

  const _Address(this.details, {Key key}) : super(key: key);

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
                      color: Colors.grey.withOpacity(0.6)),
                ),
                Text(
                  details.address,
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
        ));
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
    String iosTaxi = "yandextaxi://";
    if (Platform.isAndroid) {
      installedTaxi = await AppAvailability.isAppEnabled(androidTaxi);
      if (installedTaxi) {
//        AppAvailability.launchApp(androidTaxi);
        final AndroidIntent intent = AndroidIntent(
            action: 'action_view',
            data: Uri.encodeFull('geo:$latitude,$longitude'),
            package: androidTaxi);
        await intent.launch();
      } else {
        OpenAppstore.launch(androidAppId: androidTaxi);
      }
    } else if (Platform.isIOS) {
      installedTaxi = await AppAvailability.isAppEnabled(iosTaxi);
      if (installedTaxi) {
        AppAvailability.launchApp(iosTaxi);
      } else {
        OpenAppstore.launch(iOSAppId: iosTaxi);
      }
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
                  child: Image.asset('images/mock_images/yandex_taxi.png'))),
          Text(
            'Вызвать такси',
            style: TextStyle(fontSize: 14, color: AppColors.darkGray),
          ),
        ],
      ),
    );
  }
}

class _QrCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 8),
            QrImage(
              data: '1234567890123456789012345678901234567890',
              version: QrVersions.auto,
              size: 160.0,
            ),
            SizedBox(height: 8),
            Text(
              'Чтобы войти, покажите \nQR-код сотруднику',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: NamedFontWeight.regular,
                  fontSize: 17,
                  color: AppColors.darkGray),
            ),
//          ),
            SizedBox(height: 12),
          ],
        ));
  }
}
/*

class _SelectTransport extends StatefulWidget {
  @override
  _SelectTransportState createState() => _SelectTransportState();
}

class _SelectTransportState extends State<_SelectTransport>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoutesBloc, RoutesState>(
      builder: (context, state) {
        if (state is RouteToGeoObjectState) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 8, 10, 12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(8),
                        topRight: const Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Откуда: мое местоположение',
                                  style: TextStyle(
                                      fontWeight: NamedFontWeight.regular,
                                      fontSize: 14,
                                      color: AppColors.gray),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Куда: ' + state.details.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: NamedFontWeight.bold,
                                    color: AppColors.darkGray,
                                  ),
                                ),
                                state.info != null ?
                                _ButtonPath(text: 'Маршрут подробно', info: state.info)
                                : SizedBox.shrink()
                                ,
                              ],
                            ),
                          ),
                        ),
                        _CancelButton(),
                      ],
                    ),
                  ),
//                  state.info != null
//                      ? RoutePathDetailsHeader(state.info)
//                      : SizedBox.shrink(),
//                  state.info != null
//                      ? RoutePathDetails(state.info)
//                      : SizedBox.shrink(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _TransportFilters(),
                  ),
                ],
              ),
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
*/

/*
class _ButtonPath extends StatelessWidget {
  const _ButtonPath(
      {Key key, this.text, this.info})
      : super(key: key);

  final String text;
  final RouteInfo info;

  static SheetState sheetState;
  static bool get isCollapsed => sheetState?.isCollapsed ?? true;
  static final dialogController = SheetController();

  @override
  Widget build(BuildContext rootContext) {
//    final mediaQuery = MediaQuery.of(rootContext);
    return GestureDetector(
      onTap: () async {
        await showSlidingBottomSheet(
            rootContext,
            builder: (context) {
              return SlidingSheetDialog(
                controller: dialogController,
//                color: Colors.transparent,
//                backdropColor: Colors.transparent,
                shadowColor: Colors.transparent,
                cornerRadius: 8,
                snapSpec: const SnapSpec(
                  snap: true,
                  snappings: [0, 0.7, 0.9],
                  positioning: SnapPositioning.relativeToAvailableSpace,
                ),
                headerBuilder: (context, state) {
                  return
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
//                        SizedBox(height: mediaQuery.padding.top+80),
                        _TapMark(),
                        Material(
                            color: Colors.transparent,
                            child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.fromLTRB(10, 8, 10, 0),
                              child:
                              RoutePathDetailsHeader(info),
                            ))
                      ],
                    );
                },
                builder: (context, state) {
                  return DefaultTextStyle(
                    style: Theme.of(rootContext).textTheme.body1,
                    child: RoutePathDetails(info),
                  );
                },
              );
            }
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
      margin: const EdgeInsets.only(top:10),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 1,
              color: AppColors.lightGray,
            ),
          ),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                text,
              )
          )
      ),
    );
  }
}
*/

class _TransportFilters extends StatefulWidget {
  _TransportFiltersState createState() => _TransportFiltersState();
}

class _TransportFiltersState extends State<_TransportFilters> {
  static const height = 54.0;
  ScrollController _controller = new ScrollController();
  RouteType routeType;

  @override
  void initState() {
    _getFiltersOnStartup().then((value) {
      print('moveItem done');
    });
    super.initState();
  }

  Future _getFiltersOnStartup() async {
    await Future.delayed(Duration(milliseconds: 500), _moveItem);
  }

  void _moveItem() {
//    print(routeType);
    double moveTo = 0;
    if (routeType == RouteType.masstransit) {
      moveTo = 0;
    }
    if (routeType == RouteType.pedestrian) {
      moveTo = _controller.position.maxScrollExtent / 4;
    }
    if (routeType == RouteType.bicycle) {
      moveTo = _controller.position.maxScrollExtent / 3;
    }
    if (routeType == RouteType.driving) {
      moveTo = _controller.position.maxScrollExtent;
    }
//    _controller.jumpTo(moveTo);
    _controller.animateTo(
      moveTo,
      curve: Curves.linear,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        child: BlocBuilder<RoutesBloc, RoutesState>(
          builder: (context, state) {
            if (state is RouteToGeoObjectState) {
              routeType = state.currentRouteType;
              return Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TransportFilterChip(
                    isActive: state.currentRouteType == RouteType.masstransit,
                    icon: 'images/bus.png',
                    iconActive: 'images/bus_active.png',
                    time: state.time[RouteType.masstransit],
                    onPressed: () {
                      _bloc(context).add(OnBuildRoute());
                    },
                  ),
                  _TransportFilterChip(
                    isActive: state.currentRouteType == RouteType.pedestrian,
                    icon: 'images/walk.png',
                    iconActive: 'images/walk_active.png',
                    time: state.time[RouteType.pedestrian],
                    onPressed: () {
                      _bloc(context).add(OnBuildPedestrianRoute());
                    },
                  ),
                  _TransportFilterChip(
                    isActive: state.currentRouteType == RouteType.bicycle,
                    icon: 'images/bike.png',
                    iconActive: 'images/bike_active.png',
                    time: state.time[RouteType.bicycle],
                    onPressed: () {
                      _bloc(context).add(OnBuildBicycleRoute());
                    },
                  ),
                  _TransportFilterChip(
                    isActive: state.currentRouteType == RouteType.driving,
                    icon: 'images/auto.png',
                    iconActive: 'images/auto_active.png',
                    time: state.time[RouteType.driving],
                    onPressed: () {
                      _bloc(context).add(OnBuildDrivingRoute());
                    },
                  ),
                ],
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
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
/*

class _SearchAndFilters extends StatefulWidget {
  final bool isOpen;
  final bool isExpanded;

  const _SearchAndFilters({
    Key key,
    this.isOpen = false,
    this.isExpanded = false,
  }) : super(key: key);

  @override
  _SearchAndFiltersState createState() => _SearchAndFiltersState();
}

class _SearchAndFiltersState extends State<_SearchAndFilters>
    with SingleTickerProviderStateMixin {
  AnimationController _openAnimation;

  @override
  void initState() {
    super.initState();

    _openAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: widget.isOpen ? 1.0 : 0.0,
    );
  }

  @override
  void dispose() {
    _openAnimation.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_SearchAndFilters oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isOpen) {
      _openAnimation.fling(velocity: 1.0);
    } else {
      _openAnimation.fling(velocity: -1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizeTransition(
        sizeFactor: _openAnimation,
        child: _SearchAndFiltersContainer(
          isExpanded: widget.isExpanded,
        ),
      ),
    );
  }
}
*/
/*

class _SearchAndFiltersContainer extends StatefulWidget {
  final bool isExpanded;

  const _SearchAndFiltersContainer({
    Key key,
    this.isExpanded = false,
  }) : super(key: key);

  @override
  _SearchAndFiltersContainerState createState() =>
      _SearchAndFiltersContainerState();
}

class _SearchAndFiltersContainerState extends State<_SearchAndFiltersContainer>
    with SingleTickerProviderStateMixin {
  AnimationController _expandAnimation;

  RoutesBloc get bloc => BlocProvider.of<RoutesBloc>(context);

  @override
  void initState() {
    super.initState();

    _expandAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: widget.isExpanded ? 1.0 : 0.0,
    );
  }

  @override
  void dispose() {
    _expandAnimation.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_SearchAndFiltersContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isExpanded) {
      _expandAnimation.fling(velocity: 1.0);
    } else {
      _expandAnimation.fling(velocity: -1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
      ),
      child:
      Column(
          mainAxisSize: MainAxisSize.min,
          children: [
//            _SearchIcon(),
            Container(
              width: double.infinity,
              color: Colors.white,
              child:
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
//          _SearchInput(),
//          _Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _Filters(),
                  ),
                  _Divider(),
                ],
              ),
            ),
          ]
      ),
    );
  }
}
*/

class _MapIcon extends StatelessWidget {
  @override
  Widget build(BuildContext rootContext) {
    final mediaQuery = MediaQuery.of(rootContext);
    return Positioned(
        right: 10,
        top: mediaQuery.padding.top + 10,
        bottom: mediaQuery.padding.bottom + 80,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: FloatingActionButton(
//                      elevation: 0.0,
                  backgroundColor: Colors.white,
                  heroTag: null,
                  onPressed: () async {
                    _bloc(rootContext).add(OnSearchFocus());

                    bool dismiss = await showModalBottomSheet(
                      context: rootContext,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (context) {
                        return BlocProvider.value(
                          value: _bloc(rootContext),
                          child: _ModalSearch(
                            topPadding: mediaQuery.padding.top,
                          ),
                        );
                      },
                    );

                    if (dismiss == null || dismiss) {
                      _bloc(rootContext).add(OnCancel());
                    }
                  },
                  child: Icon(
                    Icons.format_list_bulleted,
                    color: AppColors.darkGray,
                    size: 30,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  FloatingActionButton(
                    isExtended: true,
                    mini: true,
                    heroTag: null,
                    child: Icon(
                      Icons.add,
                      color: AppColors.darkGray,
                      size: 30,
                    ),
                    backgroundColor: Colors.white,
                    onPressed: () {},
                  ),
                  FloatingActionButton(
                    mini: true,
                    heroTag: null,
                    /*shape:
                            ContinuousRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(50),
                                    bottomLeft: Radius.circular(50)
                                )
                            ),*/
                    child: Icon(
                      Icons.remove,
                      color: AppColors.darkGray,
                      size: 30,
                    ),
                    backgroundColor: Colors.white,
                    onPressed: () {},
                  ),
                ]),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  heroTag: null,
                  onPressed: () async {
                    _bloc(rootContext).add(OnSearchFocus());

                    bool dismiss = await showModalBottomSheet(
                      context: rootContext,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (context) {
                        return BlocProvider.value(
                          value: _bloc(rootContext),
                          child: _ModalSearch(
                            topPadding: mediaQuery.padding.top,
                            inputFocus: true,
                          ),
                        );
                      },
                    );

                    if (dismiss == null || dismiss) {
                      _bloc(rootContext).add(OnCancel());
                    }
                  },
                  child: Icon(
                    Icons.search,
                    color: AppColors.darkGray,
                    size: 30,
                  ),
                ),
              ),
            ]));
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDivider(height: 1, color: rgba(203, 205, 204, 0.5));
  }
}

class _SearchInput extends StatefulWidget {
  static const height = 54.0;

  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends State<_SearchInput> {
  final _focusNode = FocusNode();
  bool _displayClose = false;
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = _bloc(context).listen((state) {
      if (state is! SearchState) {
        _focusNode.unfocus();
      }
    });

    _focusNode.addListener(() {
      setState(() {
        _displayClose = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext rootContext) {
    final mediaQuery = MediaQuery.of(rootContext);

    return GestureDetector(
      onTap: () async {
        _bloc(rootContext).add(OnSearchFocus());

        bool dismiss = await showModalBottomSheet(
          context: rootContext,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) {
            return BlocProvider.value(
              value: _bloc(rootContext),
              child: _ModalSearch(
                topPadding: mediaQuery.padding.top,
              ),
            );
          },
        );

        if (dismiss == null || dismiss) {
          _bloc(rootContext).add(OnCancel());
        }
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 8, 10, 12),
            decoration: BoxDecoration(
              color: AppColors.primaryRed,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(8),
                topRight: const Radius.circular(8),
              ),
            ),
            child: SizedBox(
              height: _SearchInput.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(Icons.search,
                          color: Colors.white.withOpacity(0.6)),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      enabled: false,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 10,
                        ),
                        disabledBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.white.withOpacity(0.6)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.white.withOpacity(0.6)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.white.withOpacity(0.6)),
                        ),
                        hintText: 'Поиск',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                  _displayClose
                      ? _CancelButton(
                    onPressed: () => Navigator.of(context).pop(true),
                  )
                      : _ListButton()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModalSearch extends StatelessWidget {
  final double topPadding;
  final bool inputFocus;

  const _ModalSearch({Key key, this.topPadding = 0, this.inputFocus = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: topPadding + 8),
            Center(
              child: Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Color(0xFFC4C4C4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.fromLTRB(10, 8, 10, 12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(8),
                  topRight: const Radius.circular(8),
                ),
              ),
              child: SizedBox(
                height: _SearchInput.height,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.search,
                          color: Colors.grey.withOpacity(0.6),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        autofocus: inputFocus,
                        onChanged: (text) {
                          _bloc(context).add(OnSearch(text));
                        },
                        style: TextStyle(color: AppColors.darkGray),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 10,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.lightGray),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.lightGray),
                          ),
                          hintText: 'Поиск',
                          hintStyle: TextStyle(
                            color: AppColors.lightGray,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: _CancelButton(
                          onPressed: () => Navigator.of(context).pop(false),
                        )),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: _SearchResults(),
              ),
            ),
          ],
        ),
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
              _bloc(context).add(OnCancel());

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

class _ListButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ListButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Align(
        alignment: Alignment.center,
        child: Icon(Icons.format_list_bulleted,
            color: Colors.white.withOpacity(0.6)),
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<RoutesBloc, RoutesState>(
        builder: (context, state) {
          if (state is SearchLoadSuggestionsErrorState) {
            return Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Произошла ошибка',
                  style: TextStyle(
                    color: AppColors.defaultValidationError,
                  ),
                ),
              ),
            );
          } else if (state is SearchLoadingSuggestionsState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is SearchState) {
            return ListView(
              children: state.suggestions
                  .map(
                    (it) => Column(
                  children: <Widget>[
                    _SearchSuggestion(it),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _Divider(),
                    ),
                  ],
                ),
              )
                  .toList(),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class _SearchSuggestion extends StatelessWidget {
  final SearchSuggestion suggestion;

  const _SearchSuggestion(this.suggestion, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          _bloc(context).add(OnSelectGeoObject(suggestion.ref));
          Navigator.of(context).pop(false);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: <Widget>[
            suggestion.image.isPresent
                ? CircleAvatar(
              backgroundImage: suggestion.image.value.match(
                    (asset) => AssetImage(asset),
                    (url) => CachedNetworkImageProvider(url),
              ),
            )
                : SizedBox.shrink(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 12.0),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        suggestion.name ?? '',
                        style: TextStyle(
                          fontWeight: NamedFontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(suggestion.address ?? ''),
                    ),
                  ),
                  SizedBox(height: 12.0),
                ],
              ),
            ),
            Text(
              suggestion.distance.isPresent ? suggestion.distance.value : '',
            ),
          ]),
        ),
      ),
    );
  }
}

class _Filters extends StatelessWidget {
  static const height = 54.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: BlocBuilder<RoutesBloc, RoutesState>(builder: (context, state) {
          if (state is LoadedMapState) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: state.days
                  .map(
                    (it) => _FilterChip(
                  day: it,
                  selectedDayRef: state.selectedDayRef,
                ),
              )
                  .toList(),
            );
          } else {
            return SizedBox.shrink();
          }
        }),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final Day day;
  final String selectedDayRef;

  bool get isActive => selectedDayRef == day.ref;

  const _FilterChip({
    Key key,
    @required this.day,
    @required this.selectedDayRef,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          onTap: () {
            _bloc(context).add(OnSelectDay(day.ref));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              day.day,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
