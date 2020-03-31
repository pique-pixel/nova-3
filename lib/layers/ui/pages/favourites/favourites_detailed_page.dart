import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rp_mobile/layers/bloc/routes/routes_models.dart';
import 'package:rp_mobile/layers/bloc/single_favorite_my_content_details/bloc.dart';
import 'package:rp_mobile/layers/bloc/single_favorite_my_content_details/single_favorite_my_content_details_models.dart';
import 'package:rp_mobile/layers/services/favorite_services.dart';
import 'package:rp_mobile/layers/services/geo_objects.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/pages/event_details.dart';
import 'package:rp_mobile/layers/ui/pages/favourites/favourites_page.dart';
import 'package:rp_mobile/layers/ui/pages/restaurant_detail.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/layers/ui/widgets/app/alerts.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/widgets/temp_widgets/temp_text_style.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../fonts.dart';

class FavouritesDetailedPageProvider extends StatelessWidget {
  final String id;

  const FavouritesDetailedPageProvider(this.id, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SingleFavoriteMyContentDetailsBloc(GetIt.instance<FavoriteService>())
            ..add(OnLoad(id)),
      child: FavouritesDetailedPage(),
    );
  }
}

SingleFavoriteMyContentDetailsBloc _bloc(BuildContext context) =>
    BlocProvider.of<SingleFavoriteMyContentDetailsBloc>(context);

class FavouritesDetailedPage extends StatefulWidget {
  static route(String id) => MaterialPageRoute(
      builder: (context) => FavouritesDetailedPageProvider(id));

  @override
  _FavouritesDetailedPageState createState() => _FavouritesDetailedPageState();
}

class _FavouritesDetailedPageState extends State<FavouritesDetailedPage> {
  YandexMapController yandexMapController;
  SheetController sheetController = SheetController();
  PanelController panelController = PanelController();
  StreamSubscription _subscription;

  double _initialLocationHeight;
  double _ratioOfOpenPanel = 0.55;
  double _panelHeightOpen;

  // NOTE(Kazbek): 88 here is defined height of the _Header widget
  // This needed to show only Header widget in collapsed mode of slider
  double _panelHeightClosed = 88;
  double _sliderValue = 1;
  double screenHeight;
  GeoObjectsService geoObjectsService;
  List<GeoObject> geoObjectList;
  GeoObject myLocationGeo;
  Point myLocationPoint;

  bool showLoading = true;

  @override
  void initState() {
    super.initState();
    geoObjectsService = GetIt.instance<GeoObjectsService>();
    _subscription = _bloc(context).listen(_handleRouting);
  }

  @override
  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
    }
    super.dispose();
  }

  void _handleRouting(SingleFavoriteMyContentDetailsState state) async {
    if (context == null) {
      return;
    }

    if (state is ListDeletedState) {
      //TODO: need fix bug with back button
      Navigator.of(context).pushReplacement(FavouritesPage.route());
    }
  }

  void _stopLoading() async {
    setState(() {
      showLoading = false;
    });
  }

  _slidingFunction(double value) {
    setState(() {
      _sliderValue = value;
    });
  }

  double zoomButtonsTopCalculatingFunction() {
    return (screenHeight -
                (_sliderValue * (_panelHeightOpen - _panelHeightClosed))) /
            2 -
        _panelHeightClosed;
  }

  double posButtonsTopCalculatingFunction() {
    return _initialLocationHeight +
        (1 - _sliderValue) * (_panelHeightOpen - _panelHeightClosed);
  }

  void _initVariablesForCalculation(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    screenHeight = mediaQuery.size.height;
    _panelHeightOpen = screenHeight * _ratioOfOpenPanel;
    _initialLocationHeight = 230 *
        ((screenHeight - _panelHeightClosed) / (683 - _panelHeightClosed));
  }

  @override
  Widget build(BuildContext context) {
    _initVariablesForCalculation(context);

    return AppScaffold(
      theme: AppThemes.materialAppTheme(),
      body: Stack(
        children: <Widget>[
          SlidingUpPanel(
            defaultPanelState: PanelState.OPEN,
            isDraggable: true,
            slideDirection: SlideDirection.UP,
            panelSnapping: true,
            body: BlocBuilder<SingleFavoriteMyContentDetailsBloc,
                SingleFavoriteMyContentDetailsState>(builder: (context, state) {
              if (state is LoadingState) {
                return _SlidingPanelProgressBar();
              } else if (state is LoadedState) {
                return _Body(
                  yandexMap: YandexMap(
                    onMapCreated: (controller) async {
                      yandexMapController = controller;
                      geoObjectsService
                          .setYandexMapController(yandexMapController);
                      myLocationPoint =
                          await geoObjectsService.getCurrentGeoLocation();
                      myLocationGeo = GeoObject(
                        ref: "0",
                        title: "My Location",
                        latitude: myLocationPoint.latitude,
                        longitude: myLocationPoint.longitude,
                      );
                      await geoObjectsService.moveCameraToBoundary(
                          state.details.activities.map((it) => it.geoData),
                          false);
                      _stopLoading();
                    },
                  ),
                  showLoading: showLoading,
                );
              } else {
                return SizedBox.shrink();
              }
            }),
            panelBuilder: (ScrollController sC) => SlidingPanel(
              scrollController: sC,
              heightOfHeader: _panelHeightClosed,
            ),
            controller: panelController,
            color: Colors.white,
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            onPanelSlide: _slidingFunction,
            parallaxEnabled: true,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            parallaxOffset: 0.50,
          ),
          Positioned(
            top: 26,
            left: 16,
            child: _BackButton(
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            top: 26,
            right: 16,
            child: _SearchButton(
              onTap: () async {
                print("Make Search");
              },
            ),
          ),
          Positioned(
            top: zoomButtonsTopCalculatingFunction(),
            right: 16,
            child: _ZoomButtons(
              onTapZoomIn: () async {
                print("ZoomIN");
                await yandexMapController.zoomIn();
              },
              onTapZoomOut: () async {
                print("ZoomOUT");
                await yandexMapController.zoomOut();
              },
            ),
          ),
          Positioned(
            top: posButtonsTopCalculatingFunction(),
            right: 16,
            child: _MyLocationButton(
              onTap: () async {
                print("Go to My location");
                myLocationPoint =
                    await geoObjectsService.getCurrentGeoLocation();
                await yandexMapController.move(
                  point: myLocationPoint,
                  animation: MapAnimation(duration: 1, smooth: true),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final bool showLoading;
  final YandexMap yandexMap;

  const _Body({
    Key key,
    @required this.showLoading,
    @required this.yandexMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        yandexMap,
        showLoading
            ? Container(
                constraints: BoxConstraints.expand(),
                color: Colors.white,
                child: Center(child: CircularProgressIndicator()),
              )
            : Container(),
      ],
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

class SlidingPanel extends StatelessWidget {
  final ScrollController scrollController;
  final double heightOfHeader;

  SlidingPanel({
    Key key,
    @required this.scrollController,
    @required this.heightOfHeader,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      constraints: BoxConstraints.tightFor(),
      child: BlocBuilder<SingleFavoriteMyContentDetailsBloc,
          SingleFavoriteMyContentDetailsState>(builder: (context, state) {
        if (state is LoadingState) {
          return _SlidingPanelProgressBar();
        }
        if (state is LoadedState) {
          return Column(
            children: <Widget>[
              _Header(
                heightOfHeader: heightOfHeader,
              ),
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: ListView.builder(
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.details.activities.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return _BottomSliderSheetCard(
                          data: state.details.activities[index],
                        );
                      },
                    )),
              ),
            ],
          );
        } else {
          return SizedBox.shrink();
        }
      }),
    );
  }
}

class _SlidingPanelProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Theme(
        data: Theme.of(context).copyWith(accentColor: Colors.white),
        child: CircularProgressIndicator(),
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
      child: Image.asset(
        "images/search_icon.png",
        scale: 0.9,
      ),
    );
  }
}

class _MyLocationButton extends StatelessWidget {
  final Function onTap;

  const _MyLocationButton({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ButtonBaseForMap(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: 2, top: 2),
        child: Image.asset(
          'images/my_location.png',
          color: Colors.black,
          alignment: Alignment.center,
          scale: 0.95,
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final double heightOfHeader;

  const _Header({
    Key key,
    @required this.heightOfHeader,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: heightOfHeader,
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _GrayMark(),
          _HeaderTitle(),
        ],
      ),
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
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SingleFavoriteMyContentDetailsBloc,
        SingleFavoriteMyContentDetailsState>(builder: (context, state) {
      if (state is LoadedState) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    state.details.name,
                    style: GolosTextStyles.h2size20(
                        golosTextColors: GolosTextColors.grayDarkVery),
                  ),
                  IconButton(
                    padding: EdgeInsets.all(0),
                    icon: Icon(
                      Icons.more_horiz,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext _) {
                          return BlocProvider.value(
                            value: _bloc(context),
                            child: _PlanActionsDialog(listId: state.details.id),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              Text(
                state.details.contentCount.toString() + " событий",
                style: GolosTextStyles.additionalSize14(
                    golosTextColors: GolosTextColors.grayDark),
              ),
              SizedBox(height: 8),
              Divider(
                height: 0,
                color: Colors.black26,
              )
            ],
          ),
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

class _PlanActionsDialog extends StatelessWidget {
  final String listId;

  const _PlanActionsDialog({Key key, @required this.listId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppChooserDialog(
      options: [
        AppDialogOption(
          title: 'Изменить название',
          onTap: () {
            //Navigator.of(context).pop();
            print('смена названия');
          },
        ),
        AppDialogOption(
          title: 'Добавить в план',
          onTap: () {},
        ),
        AppDialogOption(
          title: 'Удалить список',
          onTap: () {
            _bloc(context).add(OnDeleteList(listId));
            //TODO: need show this dialog with bloc context
            // showDialog(
            //   context: context,
            //   builder: (BuildContext _) {
            //     return YesNoDialog(
            //       title: 'Удалить список',
            //       text: 'Вы уверены, что хотите удалить список?',
            //       cancelOption: 'Отменить',
            //       okOption: 'Удалить',
            //       onSuccess: () {
            //         _bloc(context).add(OnDeleteList(listId));
            //       },
            //     );
            //   },
            // );
          },
        ),
      ],
    );
  }
}

class _BottomSliderSheetCard extends StatelessWidget {
  final FavoriteMyDetailItemModel data;

  const _BottomSliderSheetCard({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double imageSide = 80;
    return Container(
      margin: EdgeInsets.only(top: 16),
      child:
      GestureDetector(
        onTap: () {
          if (data.type == 'EVENT') {
            Navigator.of(context).push(EventDetailPage.route(data.id));
          }
          if (data.type == 'RESTAURANT') {
            Navigator.of(context)
                .push(RestaurantDetailPage.route(data.id));
          }
        },
        child:
        Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: data.image,
                  placeholder: (context, str) =>
                      Center(child: CircularProgressIndicator()),
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      height: imageSide,
                      width: imageSide,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        data.title,
                        style: TextStyle(
                          color: GolosTextColors.grayDarkVery,
                          fontWeight: FontWeight.w500,
                          fontFamily: GolosTextStyles.fontFamily,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        data.address,
                        style: GolosTextStyles.additionalSize14(
                            golosTextColors: GolosTextColors.grayDark),
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
                  onPressed: () {},
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
}
