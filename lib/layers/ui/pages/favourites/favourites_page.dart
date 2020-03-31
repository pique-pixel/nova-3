import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rp_mobile/layers/bloc/favorites/bloc.dart';
import 'package:rp_mobile/layers/services/favorite_services.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/pages/favourites/body.dart';
import 'package:rp_mobile/layers/ui/pages/favourites/favourites_detailed_page.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/widgets/base/bottom_nav_bar.dart';
import 'package:rp_mobile/layers/ui/widgets/temp_widgets/ios_loading_indicator.dart';
import 'package:rp_mobile/layers/ui/widgets/temp_widgets/temp_text_style.dart';

class FavouritesPageProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoriteBloc>(
      create: (context) =>
          FavoriteBloc(GetIt.instance<FavoriteService>())..add(OnLoad()),
      child: FavouritesPage(),
    );
  }
}

FavoriteBloc _bloc(BuildContext context) =>
    BlocProvider.of<FavoriteBloc>(context);

class FavouritesPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => FavouritesPageProvider());

  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage>
    with SingleTickerProviderStateMixin {
  bool isEmptyMain = false;
  TabController tabContoller;

  GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController createFavoriteController = TextEditingController();
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    tabContoller = TabController(length: 3, initialIndex: 0, vsync: this);
    _subscription = _bloc(context).listen(_handleRouting);
  }

  @override
  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
    }
    super.dispose();
  }

  void _handleRouting(FavoriteState state) async {
    if (context == null) {
      return;
    }

    if (state is RouteToDetailState) {
      Navigator.of(context).push(
        FavouritesDetailedPage.route(state.id),
      );
      _bloc(context).add(OnRouteTrigger());
    }

    if (state is BottomSheetShowState) {
      createFavoriteController.clear();

      await showCreateFavoriteBottomSheet(
        context: scaffoldKey.currentContext,
        textEditingController: createFavoriteController,
        onTapContinue: () async {
          final String listName = createFavoriteController.text;
          if (listName.isNotEmpty) {
            _bloc(context).add(OnCreateNewList(listName));
          }
          Navigator.of(context).maybePop();
        },
      );
      _bloc(context).add(OnBottomSheetClose());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      theme: AppThemes.materialAppTheme(),
      bottomNavigationBar: BottomNavBar(index: BottomNavPageIndex.favourites),
      key: scaffoldKey,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            SizedBox(height: 36),
            _Header(
              onPressed: () async {
                _bloc(context).add(OnBottomSheetShow());
              },
            ),
            Expanded(
              child: FavouritesBody(
                isEmpty: isEmptyMain,
                tabController: tabContoller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showCreateFavoriteBottomSheet({
  @required BuildContext context,
  @required TextEditingController textEditingController,
  @required Function onTapContinue,
}) async {
  bool validate = false;

  await showModalBottomSheet(
    context: context,
    isDismissible: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter rebuildController) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                constraints: BoxConstraints.tightFor(),
                padding: EdgeInsets.only(
                  top: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _FavoriteBottomSheetTitle(),
                    SizedBox(
                      height: 16,
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    _FavoriteBottomSheetTextFieldAndButton(
                      textEditingController: textEditingController,
                      onTap: () async {
                        if (textEditingController.text.isNotEmpty) {
                          rebuildController(() {
                            validate = true;
                          });
                          await onTapContinue();
                        }
                      },
                      validate: validate,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

class _FavoriteBottomSheetTextFieldAndButton extends StatelessWidget {
  final TextEditingController textEditingController;
  final Function onTap;
  final bool validate;

  _FavoriteBottomSheetTextFieldAndButton({
    Key key,
    @required this.textEditingController,
    this.onTap,
    this.validate = false,
  }) : assert(textEditingController != null);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: textEditingController,
                autocorrect: false,
                enableInteractiveSelection: true,
                decoration: InputDecoration(
                  hintText: "Введите название",
                  errorText: validate ? null : 'Название списка не должно быть пустым',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback(
                          (_) => textEditingController.clear());
                    },
                  ),
                ),
                enabled: true,
                keyboardType: TextInputType.text,
                cursorColor: AppColors.primaryRed,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 36,
      ),
      FlatButton(
        onPressed: onTap,
        padding: EdgeInsets.all(0),
        child: Container(
          color: AppColors.primaryRed,
          width: double.infinity,
          height: 54,
          alignment: Alignment.center,
          child: validate
              ? IosLoadingIndicator()
              : Text(
                  "Продолжить",
                  style: GolosTextStyles.h3size16(
                      golosTextColors: GolosTextColors.white),
                ),
        ),
      ),
    ]);
  }
}

class _FavoriteBottomSheetTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        "Создать новый список",
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: "PT Russia Text",
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Function onPressed;

  const _Header({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Избранное",
            style: GolosTextStyles.h1size30(
              golosTextColors: GolosTextColors.grayDarkVery,
            ),
          ),
          _ButtonCreate(
            text: "Создать",
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}

class _ButtonCreate extends StatelessWidget {
  final String text;
  final Function onPressed;

  const _ButtonCreate({Key key, @required this.text, @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: AppColors.white80,
      child: Text(
        "Создать",
        style: GolosTextStyles.buttonStyleSize14(
          golosTextColors: GolosTextColors.grayDarkVery,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
