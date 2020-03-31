import 'package:cached_network_image/cached_network_image.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rp_mobile/layers/bloc/restaurant_detail/restaurant_detail_bloc.dart';
import 'package:rp_mobile/layers/bloc/restaurant_detail/restaurant_detail_event.dart';
import 'package:rp_mobile/layers/bloc/restaurant_detail/restaurant_detail_state.dart';
import 'package:rp_mobile/layers/services/restaurant_detail_service.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/widgets/base/fade_background.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rp_mobile/layers/bloc/plans/bloc.dart';
import 'package:rp_mobile/layers/bloc/plans/plans_models.dart';
import 'package:rp_mobile/layers/services/plans_service.dart';
import 'package:rp_mobile/layers/ui/widgets/base/bottom_sheet.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_bottom_sheet_decoration.dart';
import 'package:rp_mobile/layers/ui/widgets/app/alerts.dart';
import 'dart:math' as math;

PlansBloc _blocPlans(BuildContext context) {
  return BlocProvider.of<PlansBloc>(context);
}

class RestaurantDetailProvider extends StatelessWidget {
  final String ref;

  const RestaurantDetailProvider(this.ref, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RestaurantDetailBloc>(
          create: (BuildContext context) => RestaurantDetailBloc(GetIt.instance<RestaurantDetailService>())..add(RestaurantOnLoad(ref)),
        ),
        BlocProvider<PlansBloc>(
          create: (BuildContext context) => PlansBloc(GetIt.instance<PlansService>())..add(OnLoad()),
        ),
      ],
      child: RestaurantDetailPage(),
    );
//    return BlocProvider(
//      builder: (context) =>
//      RestaurantDetailBloc(GetIt.instance<RestaurantDetailService>())
//        ..add(OnLoad(ref)),
//      child: RestaurantDetailPage(),
//    );
  }
}

class RestaurantDetailPage extends StatelessWidget {
  static route(String ref) =>
      MaterialPageRoute(builder: (context) => RestaurantDetailProvider(ref));

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      theme: AppThemes.pageBrightnessLightTheme(),
      body: SafeArea(
        child: Scaffold(
          body: BlocBuilder<RestaurantDetailBloc,
              RestaurantDetailState>(
            builder: (context, state) {
              if (state is RestaurantLoadingState) {
                return Center(child: CircularProgressIndicator());
              } else if (state is RestaurantLoadedState) {
                return RestaurantDetailBody();
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

class RestaurantDetailBody extends StatefulWidget {
  @override
  _RestaurantDetailBodyState createState() => _RestaurantDetailBodyState();
}

class _RestaurantDetailBodyState extends State<RestaurantDetailBody> {

  ScrollController _controller;
  double scrollOffset = 100;
  double _opacityDuration = 1.0;
  bool _showDuration = true;

  _scrollListener() {
    if (_controller.offset >= scrollOffset) {
      setState(() {
        _showDuration = false;
      });
    }
    if (_controller.offset <= scrollOffset) {
      setState(() {
        _opacityDuration = 1 - _controller.offset / scrollOffset;
        _showDuration = true;
      });
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return CustomScrollView(
      controller: _controller,
      physics: ClampingScrollPhysics(),
      slivers: <Widget>[
        SliverPersistentHeader(
          pinned: true,
          delegate: _SliverAppBarDelegate(
            minHeight: 80.0 + mediaQuery.padding.top,
            maxHeight: 200.0 + mediaQuery.padding.top,
            child: Container(
              color: Colors.white,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: BlocBuilder<RestaurantDetailBloc,
                        RestaurantDetailState>(
                      builder: (context, state) {
                        if (state is RestaurantLoadedState) {
                          return FadeBackgroundImage(
                            state.details.headerThumbnail.match(
                                  (asset) => AssetImage(asset),
                                  (url) => CachedNetworkImageProvider(url),
                            ),
                            backgroundColor: Color(0xFFD8D8D8),
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                  SafeArea(bottom: false, child: _AppBar()),
                  BlocBuilder<RestaurantDetailBloc,
                      RestaurantDetailState>(
                      builder: (context, state) {
                        if (state is RestaurantLoadedState) {
                          bool _durationNotEmpty = state.details.duration
                              .isNotEmpty;
                          bool _priceNotEmpty = state.details.price.isNotEmpty;
                          return Positioned(
                            bottom: 20,
                            child:
                            _showDuration
                                ?
                            Opacity(
                              opacity: _opacityDuration,
                              child:
                              Row(
                                  children: <Widget>[
                                    _durationNotEmpty
                                        ? Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      margin: const EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        color: AppColors.backgroundGray,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(state.details.duration),
                                    )
                                        : SizedBox.shrink(),
                                    _priceNotEmpty
                                        ? Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      margin: const EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        color: AppColors.backgroundGray,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(state.details.price),
                                    )
                                        : SizedBox.shrink(),
                                  ]
                              ),
                            )
                                : SizedBox.shrink(),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      }
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              _Header(),
              CarouselWithIndicator(),
              _LinkSource(),
              _Map(),
              SizedBox(height: mediaQuery.padding.bottom),
            ],
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 6, 0, 4),
            child: BlocBuilder<RestaurantDetailBloc,
                RestaurantDetailState>(builder: (context, state) {
              if (state is RestaurantLoadedState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      state.details.title,
                      style: TextStyle(
                        color: AppColors.darkGray,
                        fontSize: 24,
                        fontWeight: NamedFontWeight.bold,
                      ),
                    ),
//                    Text(
//                      'Откроется завтра',
//                      style: TextStyle(color: AppColors.gray),
//                    ),
                    SizedBox(height: 26),
                    Divider(
                      height: 0,
                      color: Colors.black26,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            state.details.address.isNotEmpty
                                ? state.details.address
                                : '',
                            style: TextStyle(color: AppColors.darkGray,
                                fontSize: 16,
                                fontWeight: NamedFontWeight.bold),
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.all(0),
                          icon:
                          Image.asset(
                            'images/route_activity_icon.png',
                            width: 26,
                            height: 26,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(
                      height: 0,
                      color: Colors.black26,
                    ),
                    SizedBox(height: 26),
                    Text(
                      'Описание',
                      style: TextStyle(
                        color: AppColors.darkGray,
                        fontSize: 18,
                        fontWeight: NamedFontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      state.details.description,
                      style: TextStyle(
                        fontSize: 17,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ],
                );
              } else {
                return SizedBox.shrink();
              }
            }),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _LinkSource extends StatelessWidget {
  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      BlocBuilder<RestaurantDetailBloc,
          RestaurantDetailState>(builder: (context, state) {
        if (state is RestaurantLoadedState) {
          String url = state.details.link;
          if (url.isNotEmpty) {
            return GestureDetector(
              onTap: () {
                _launchURL(url);
              },
              child:
              Container(
                padding: EdgeInsets.symmetric(horizontal: 18),
                margin: EdgeInsets.only(bottom: 26),
                child:
                Text(
                  'Официальный сайт',
                  style: TextStyle(
                    fontSize: 17,
                    color: AppColors.primaryRed,
                  ),
                ),
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        } else {
          return SizedBox.shrink();
        }
      }
      );
  }
}

class CarouselWithIndicator extends StatefulWidget {
  @override
  _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState();
}

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return
      BlocBuilder<RestaurantDetailBloc,
          RestaurantDetailState>(builder: (context, state) {
        if (state is RestaurantLoadedState) {
          final eventImages = state.details.images;
          if(eventImages.length>0) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CarouselSlider(
                    height: 200.0,
                    enableInfiniteScroll: true,
                    onPageChanged: (index) {
                      setState(() {
                        _current = index;
                      });
                    },
                    items: eventImages.map((img) {
                      return Builder(
                        builder: (BuildContext context) {
                          return
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration:
                              BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(img),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                        },
                      );
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: map<Widget>(eventImages, (index, url) {
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current == index
                                ? AppColors.darkGray
                                : AppColors.gray
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 24),
                ]
            );
          }else{
            return SizedBox.shrink();
          }
        } else {
          return SizedBox.shrink();
        }
      }
      );
  }
}

class _Map extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      BlocBuilder<RestaurantDetailBloc,
          RestaurantDetailState>(builder: (context, state) {
        if (state is RestaurantLoadedState) {
          return SizedBox(
            height: 160,
            width: double.infinity,
            child: YandexMap(
              onMapCreated: (controller) async {
                await controller.setBounds(
                  southWestPoint: Point(
                    latitude: state.details.coordinates.lat - 0.02,
                    longitude: state.details.coordinates.lng - 0.02,
                  ),
                  northEastPoint: Point(
                    latitude: state.details.coordinates.lat + 0.02,
                    longitude: state.details.coordinates.lng + 0.02,
                  ),
                );
                await controller.addPlacemark(
                  Placemark(
                    point: Point(
                      latitude: state.details.coordinates.lat,
                      longitude: state.details.coordinates.lng,
                    ),
                    iconName: 'images/placemark.png',
                    opacity: 1.0,
                  ),
                );
              },
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      }
      );
  }
}


class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      BlocBuilder<RestaurantDetailBloc,
          RestaurantDetailState>(builder: (context, state) {
        if (state is RestaurantLoadedState) {
          final activityId = state.details.id;
          return
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 60,
                    child: Material(
                      color: Colors.transparent,
                      child: Row(
                        children: <Widget>[
                          BackButton(color: Colors.white),
                          Expanded(child: SizedBox.shrink()),
                          IconButton(
                            padding: EdgeInsets.all(0),
                            icon:
                            Icon(
                              Icons.favorite_border,
                              color: AppColors.white,
                            ),
//                            Icon(
//                              Icons.favorite,
//                              color: AppColors.primaryRed,
//                            ),
                            onPressed: () {},
                          ),
                          IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(
                              Icons.add,
                              color: AppColors.white,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                ModalBottomSheetRoute(
                                  maxHeightFactory: 1,
                                  builder: (_) =>
                                      BlocProvider.value(
                                        value: _blocPlans(context),
                                        child: _BottomPlanSheet(activityId),
                                      ),
                                  decoratorBuilder: (_, child) =>
                                      AppBottomSheetDecoration(child: child),
                                ),
                              );
                              _blocPlans(context).add(OnLoad());
                            },
                          ),
                          SizedBox(width: 18),
                        ],
                      ),
                    ),
                  ),
                ]
            );
        } else {
          return SizedBox.shrink();
        }
      }
      );
  }
}

class _BottomPlanSheet extends StatelessWidget {
  final String activityId;

  const _BottomPlanSheet(this.activityId, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlansBloc, PlansState>(
        builder: (context, state) {
          if (state is LoadingListState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 8),
                Container(
                  color: Colors.white,
                  height: 130,
                  child: Center(child: CircularProgressIndicator()),
                )
              ],
            );
          } else if (state is LoadedState) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 16),
                  state.items.isEmpty ?
                  Container(
                    color: Colors.white,
                    height: 130,
                    child: Center(
                      child:
                      Text(
                        'У вас пока нет поездок',
                        style: TextStyle(
                          fontWeight: NamedFontWeight.bold,
                          fontSize: 20,
                          color: AppColors.darkGray,
                        ),
                      ),
                    ),
                  )
                      : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: state.items
                          .map(
                            (it) =>
                            _Item(
                                activityId: activityId,
                                item: it
                            ),
                      ).toList(),
                    ),
                  ),
                  SizedBox(height: 8),
                ]
            );
          } else {
            return SizedBox.shrink();
          }
        }
    );
  }
}

class _Item extends StatelessWidget {
  final String activityId;
  final PlanItemModel item;

  const _Item({
    Key key,
    this.activityId,
    this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
        onTap: () {
          _blocPlans(context).add(OnAddActivityToPlan(item.title.localize(context),activityId,'RESTAURANT'));
          Navigator.of(context).pop();
          //TODO как показать, что добавлено план
//          showDialog(
//            useRootNavigator: false,
//            context: context,
//            barrierDismissible: false,
//            builder: (BuildContext _) {
//              return BlocProvider.value(
//                value: _blocPlans(context),
//                child: LoadingDialog(text: 'Добавление в план поездки'),
//              );
//            },
//          );
        },
        child:
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 120,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(4),
                  image: item.thumbnail.isPresent
                      ? DecorationImage(
                    image: item.thumbnail.value.match(
                          (asset) => AssetImage(asset),
                          (url) => CachedNetworkImageProvider(url),
                    ),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: !item.thumbnail.isPresent
                    ? Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Image(
                      image: AssetImage('images/empty_plan.png'),
                    ),
                  ),
                )
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  item.title.localize(context),
                  style: TextStyle(
                    fontWeight: NamedFontWeight.regular,
                    color: AppColors.darkGray,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}