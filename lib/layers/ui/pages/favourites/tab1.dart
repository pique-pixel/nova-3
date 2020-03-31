import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rp_mobile/layers/bloc/favorites/bloc.dart';
import 'package:rp_mobile/layers/bloc/favorites/favorite_models.dart';
import 'package:rp_mobile/layers/ui/widgets/temp_widgets/temp_text_style.dart';
import 'package:rp_mobile/utils/bloc.dart';
import 'package:rp_mobile/layers/ui/widgets/app/alerts.dart';
import 'package:rp_mobile/layers/ui/colors.dart';

FavoriteBloc _bloc(BuildContext context) =>
    BlocProvider.of<FavoriteBloc>(context);

class FavouritesTabView1 extends StatefulWidget {
  @override
  _FavouritesTabView1State createState() => _FavouritesTabView1State();
}

class _FavouritesTabView1State extends State<FavouritesTabView1> {
  final _key = GlobalKey();
  StreamSubscription _subscription;
  bool thisLoadDialog = false;

  @override
  void initState() {
    super.initState();
//    print('---initState---showDialog---$thisLoadDialog');
    _subscription = _bloc(context).listen(_handleRouting);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _showLoaderDialog() {
    final result = showDialog(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext _) {
        return BlocProvider.value(
          value: _bloc(context),
          child: LoadingDialog(text: 'Создание плана поездки'),
        );
      },
    );
    setState(() {
      thisLoadDialog = true;
    });

    result.then((value) {
      print('dialog was closed $value');
      setState(() {
        thisLoadDialog = false;
      });
    });
  }

  void _handleRouting(FavoriteState state) async {
    if (context == null) {
      return;
    }

    print('---state $state');

    if (state is LoadedFavoriteForPlanState) {
      final planData = state.details;
      _bloc(context).add(OnCreateNewPlan(planData.name, planData.activities));
      _showLoaderDialog();
    }
    if (state is FavoriteCreatePlanState) {
        new Future.delayed(const Duration(seconds: 5), () {
          if (thisLoadDialog) {
            Navigator.of(context).pop();
          }
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, _state) {
              final state = unwindCascadeState(_state);
              if (state is LoadingState) {
                return CircularProgressIndicator();
              } else if (state is LoadedState) {
                return _mapToLoadedState(state);
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _mapToLoadedState(LoadedState state) {
    return ListView(
      key: _key,
      children: state.items.my
          .map((it) => _ListCard(
                data: it,
              ))
          .toList(),
    );
  }
}

class _ListCard extends StatelessWidget {
  final FavoriteMyItemModel data;

  _ListCard({
    Key key,
    @required this.data,
  }) : assert(data.images.length > 0, 'Image list cannot be empty');

  final double borderRadius = 12;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          _bloc(context).add(OnFavoriteDetails(data.id));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 8),
            Stack(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.5,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: _CustomContainer(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(borderRadius),
                              bottomLeft: Radius.circular(borderRadius),
                              topRight: Radius.circular(borderRadius),
                              bottomRight: Radius.circular(borderRadius)),
                          url: data.images[0].url,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      _bloc(context).add(OnLoadFavoriteForPlan(data.id));
                    },
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black54,
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              data.name,
              style: GolosTextStyles.h3size16(
                  golosTextColors: GolosTextColors.grayDarkVery),
            ),
            SizedBox(height: 4),
            Text(
              "${data.contentCount} точек",
              style: GolosTextStyles.mainTextSize16(
                  golosTextColors: GolosTextColors.grayDark),
            ),
            SizedBox(height: 8),
            Divider(),
          ],
        ),
      ),
    );
  }
}

class _CustomContainer extends StatelessWidget {
  final BorderRadius borderRadius;
  final String url;

  const _CustomContainer(
      {Key key, @required this.borderRadius, @required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO КОСТЫЛЬ, сделать как в дизайне
    //TODO переделать на ImageEither
    return url != ""
        ? CachedNetworkImage(
            imageUrl: url,
            imageBuilder: (BuildContext context, ImageProvider imageProvider) {
              return Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: imageProvider,
                  ),
                ),
              );
            },
          )
        : Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: AppColors.backgroundGray,
            ),
            child: Center(
              child: Icon(
                Icons.favorite,
                size: 200.0,
                color: Colors.white,
              ),
            ),
          );
  }
}

class ListCardData {
  final String title;
  final int placeNumber;
  final List<String> urls;

  ListCardData({
    this.title,
    this.placeNumber,
    this.urls,
  });
}
