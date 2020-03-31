import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rp_mobile/layers/bloc/startup/bloc.dart';
import 'package:rp_mobile/layers/bloc/startup/route.dart';
import 'package:rp_mobile/layers/bloc/startup/startup_bloc.dart';
import 'package:rp_mobile/layers/services/session.dart';
import 'package:rp_mobile/layers/ui/app_icons.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/pages/faq_help.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/widgets/base/buttons.dart';
import 'package:rp_mobile/layers/ui/widgets/base/scroll_behavior.dart';

class TipsPageProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<StartupBloc>(
      create: (context) => StartupBloc(GetIt.instance.get<SessionService>()),
      child: TipsPage(),
    );
  }
}

class TipsPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => TipsPageProvider());

  @override
  _TipsPageState createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final _tween = [1.0, 0.0, 0.0];

  @override
  void initState() {
    super.initState();

    BlocProvider.of<StartupBloc>(context)
        .listen((state) => handleStartupRouting(context, state));

    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      theme: AppThemes.materialAppTheme(),
      safeAreaTop: true,
      background: Align(
        alignment: Alignment.topCenter,
        child: Image.asset('images/tips.png'),
      ),
      body:
      Column(

          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 9, right: 5),
                child: _FaqButton(),
              ),
            ),
//          SizedBox(
//            height: 250,
//          ),
            Spacer(),
            Image.asset(
              'images/logo.png',
              height: 50,
            ),
            SizedBox(height: 24),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 90,
              ),
              child: NotificationListener<ScrollNotification>(
                onNotification: _handleScrollNotification,
                child: ScrollConfiguration(
                  behavior: NoGlowScrollBehavior(),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _TabPageView(
                        'Получите визу в Россию\n'
                            'за 96 часов без \n'
                            'посещения посольства\n',
                      ),
                      _TabPageView(
                        'RUSSPASS – ваш личный\n'
                            'гид по неповторимым\n'
                            'впечатлениям в России\n',
                      ),
                      _TabPageView(
                        'К вашим услугам готовые \n'
                            'туристические пакеты, туры\n'
                            'и конструктор путешествий\n',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _Dots(_tween),
//          Spacer(),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: SizedBox(
                width: double.infinity,
                child: ThemedRaisedButton(
                  buttonTheme: AppThemes.bigButtonTheme(),
                  child: Text('Продолжить'),
                  onPressed: () {
                    BlocProvider.of<StartupBloc>(context).add(OnCloseTips());
                  },
                ),
              ),
            ),
            SizedBox(height: 34)
          ]
      ),
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    _tween[0] = 0.0;
    _tween[1] = 0.0;
    _tween[2] = 0.0;

    setState(() {
      _tween[0] = _tabTweenValue(0, notification);
      _tween[1] = _tabTweenValue(1, notification);
      _tween[2] = _tabTweenValue(2, notification);
    });

    return true;
  }

  double _tabTweenValue(int index, ScrollNotification notification) {
    final c = notification.metrics.viewportDimension * index;
    final p = notification.metrics.viewportDimension;
    final x = notification.metrics.pixels;
    final v = 1 - (x - c).abs() / p;
    return v.clamp(0.0, 1.0);
  }
}

class _Dots extends StatelessWidget {
  final List<double> _tween;

  const _Dots(this._tween) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 17,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _TabIndicator(isSelectedTweenFactor: _tween[0]),
          _TabIndicator(isSelectedTweenFactor: _tween[1]),
          _TabIndicator(isSelectedTweenFactor: _tween[2]),
        ],
      ),
    );
  }
}

class _TabIndicator extends StatelessWidget {
  final double isSelectedTweenFactor;

  const _TabIndicator({
    Key key,
    @required this.isSelectedTweenFactor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: _getTabIndicatorSize(isSelectedTweenFactor),
        height: _getTabIndicatorSize(isSelectedTweenFactor),
        decoration: BoxDecoration(
          color: Color.lerp(
            AppColors.lightGray,
            AppColors.primaryRed,
            isSelectedTweenFactor,
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  double _getTabIndicatorSize(double isSelectedTweenFactor) {
    return 2 * isSelectedTweenFactor + 5;
  }
}

class _TabPageView extends StatelessWidget {
  const _TabPageView(this.tip, {Key key}) : super(key: key);

  final String tip;

  @override
  Widget build(BuildContext context) {
    return Text(
      tip,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'PT Russia Text',
        fontSize: 17,
        letterSpacing: -0.1,
        height: 24 / 17,
        color: AppColors.darkGray,
      ),
    );
  }
}

class _FaqButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        AppIcons.question,
        color: Colors.white,
        size: 24,
      ),
      onPressed: () {
        Navigator.push(context, FaqHelpPage.route());
      },
    );
  }
}
