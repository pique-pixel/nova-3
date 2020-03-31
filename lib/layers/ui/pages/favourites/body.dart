import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rp_mobile/layers/bloc/favorites/bloc.dart';
import 'package:rp_mobile/layers/ui/pages/favourites/tab1.dart';
import 'package:rp_mobile/layers/ui/pages/favourites/tab2.dart';
import 'package:rp_mobile/layers/ui/pages/favourites/tab3.dart';
import 'package:rp_mobile/layers/ui/widgets/temp_widgets/temp_text_style.dart';
import 'package:rp_mobile/utils/bloc.dart';

FavoriteBloc _bloc(BuildContext context) =>
    BlocProvider.of<FavoriteBloc>(context);

class FavouritesBody extends StatelessWidget {
  final bool isEmpty;
  final TabController tabController;

  FavouritesBody({Key key, @required this.isEmpty, this.tabController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, _state) {
        final state = unwindCascadeState(_state);

        if (state is LoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is LoadedState) {
          //TODO: mb need change condition
          return state.items.my.length > 0
              ? _TabbedState(tabController: tabController)
              : _NoContentState();
        } else if (state is LoadingListErrorState) {
          return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Не удалось загрузить билеты',
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(height: 24),
          RaisedButton(
            child: Text('Повторить попытку'),
            onPressed: () {
              _bloc(context).add(OnLoad());
            },
          ),
          SizedBox(height: 24),
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

class _TabbedState extends StatelessWidget {
  final TabController tabController;

  const _TabbedState({Key key, this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyleSelected = TextStyle(
      color: GolosTextColors.grayDarkVery,
      fontSize: 16,
      fontFamily: GolosTextStyles.fontFamily,
      height: 1.25,
      letterSpacing: -0.1,
      fontWeight: FontWeight.w500,
    );
    TextStyle textStyleUnselected = TextStyle(
      color: GolosTextColors.grayDark,
      fontSize: 16,
      fontFamily: GolosTextStyles.fontFamily,
      height: 1.25,
      letterSpacing: -0.1,
      fontWeight: FontWeight.w400,
    );
    return Column(
      children: <Widget>[
        TabBar(
          indicatorPadding: EdgeInsets.all(0),
          controller: tabController,
          isScrollable: true,
          labelStyle: textStyleSelected,
          unselectedLabelStyle: textStyleUnselected,
          indicatorColor: GolosTextColors.grayDarkVery,
          labelPadding: EdgeInsets.symmetric(horizontal: 12),
          tabs: [
            Tab(child: Text("Мои списки")),
            Tab(child: Text("Туристические пакеты")),
            Tab(child: Text("Туры")),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              FavouritesTabView1(),
              FavouritesTabView2(),
              FavouritesTabView3(),
            ],
          ),
        ),
      ],
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
                "Список избранного пуст",
                style: GolosTextStyles.h2size20(
                    golosTextColors: GolosTextColors.grayDarkVery),
              ),
              SizedBox(height: 8),
              Container(
                width: 230,
                child: RichText(
                  softWrap: true,
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: GolosTextStyles.fontFamily,
                      color: GolosTextColors.grayDark,
                      height: 1.3,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: "Нажмите на ",
                      ),
                      WidgetSpan(
                        child: Image.asset(
                          'images/favorite_active.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                      TextSpan(
                        text: ", что бы добавить места или события в избранное",
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        _WideButton(
          text: "Добавить новые места",
          onPressed: () {},
          textGolosColors: GolosTextColors.white,
          buttonGolosColor: GolosTextColors.red,
          buttonHighlightGolosColor: GolosTextColors.redMiddle,
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

class _WideButton extends StatelessWidget {
  final String text;
  final Color textGolosColors;
  final Function onPressed;
  final Color buttonGolosColor;
  final Color buttonHighlightGolosColor;

  const _WideButton({
    Key key,
    @required this.buttonGolosColor,
    @required this.text,
    @required this.onPressed,
    @required this.textGolosColors,
    @required this.buttonHighlightGolosColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      color: buttonGolosColor,
      splashColor: Colors.white10,
      highlightColor: buttonHighlightGolosColor,
      child: Container(
        height: 54,
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: textGolosColors,
            fontSize: 16,
            fontFamily: GolosTextStyles.fontFamily,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.1,
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
