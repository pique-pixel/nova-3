import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rp_mobile/layers/bloc/plans/bloc.dart';
import 'package:rp_mobile/layers/bloc/plans/plans_models.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/pages/explorer.dart';
import 'package:rp_mobile/layers/ui/widgets/app/buttons.dart';

PlansBloc _bloc(BuildContext context) => BlocProvider.of<PlansBloc>(context);

class PlanFill extends StatefulWidget {
  @override
  _PlanFillState createState() => _PlanFillState();
}

class _PlanFillState extends State<PlanFill> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  Completer _refreshCompleter = Completer()..complete();
  bool _allowPaging = true;
  final _key = GlobalKey();
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = _bloc(context).listen((state) {
      if (context == null) {
        return;
      }

      if (state is! RefreshingListState) {
        if (_refreshCompleter != null && !_refreshCompleter.isCompleted) {
          _refreshCompleter.complete();
        }
      }
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (!_allowPaging) {
      return;
    }

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= _scrollThreshold) {
      _bloc(context).add(OnNextPage());
      _allowPaging = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlansBloc, PlansState>(builder: (context, state) {
      if (state is LoadingListState) {
        return _mapToLoadingListState();
      } else if (state is LoadingPageState) {
        return _mapToLoadingPageState(state);
      } else if (state is LoadedState) {
        return _mapToLoadedState(state);
      } else {
        return SizedBox.shrink();
      }
    });
  }

  Widget _mapToLoadingListState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Theme(
          data: ThemeData(accentColor: AppColors.primaryRed),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _mapToLoadedState(LoadedState state) {
    _allowPaging = true;

    if (state.items.isEmpty) {
      return _NoContentState();
    } else {
      return RefreshIndicator(
        child: ListView(
          key: _key,
          controller: _scrollController,
          padding: const EdgeInsets.only(bottom: 16.0),
          children: state.items.map((it) => _ListCard(it)).toList(),
        ),
        onRefresh: () async {
          _allowPaging = false;
          _refreshCompleter = Completer();
          _bloc(context).add(OnRefresh());
          await _refreshCompleter.future;
        },
      );
    }
  }

  Widget _mapToLoadingPageState(LoadingPageState state) {
    final children = <Widget>[];

    children.addAll(state.items.map((it) => _ListCard(it)));
    children.add(SizedBox(height: 16.0));
    children.add(
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator()),
      ),
    );

    return ListView(
      key: _key,
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 16.0),
      children: children,
    );
  }
}

class _ListCard extends StatelessWidget {
  final PlanItemModel item;

  _ListCard(
    this.item, {
    Key key,
  });

  final double borderRadius = 12;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          BlocProvider.of<PlansBloc>(context).add(OnSelectItem(item.ref));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 16),
              height: 188,
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4.0),
                  topLeft: Radius.circular(4.0),
                ),
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
                        width: 60,
                        height: 60,
                        child: Image(
                          image: AssetImage('images/empty_plan.png'),
                        ),
                      ),
                    )
                  : null,
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundGray,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(4.0),
                  bottomRight: Radius.circular(4.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    item.title.localize(context),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: NamedFontWeight.bold,
                      color: AppColors.darkGray,
                    ),
                  ),
                  Text(
                    item.subTitle.localize(context),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: NamedFontWeight.regular,
                      color: AppColors.mediumGray,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoContentState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'У вас пока нет поездок',
                style: TextStyle(
                  fontWeight: NamedFontWeight.bold,
                  fontSize: 20,
                  color: AppColors.darkGray,
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: 230,
                child: RichText(
                  softWrap: true,
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: AppColors.darkGray,
                      height: 1.3,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: 'Нажмите на ',
                      ),
                      WidgetSpan(
                        child: Icon(
                          Icons.add,
                          color: AppColors.primaryRed,
                          size: 24,
                        ),
                      ),
                      TextSpan(
                        text: ', что бы добавить места или события в план '
                            'поездки',
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        BigRedRoundedButton(
          text: 'Добавить новые места',
          onPressed: () {
            Navigator.of(context).pushReplacement(ExplorerPage.route());
          },
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
