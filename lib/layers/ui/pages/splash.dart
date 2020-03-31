import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rp_mobile/layers/bloc/startup/bloc.dart';
import 'package:rp_mobile/layers/bloc/startup/route.dart';
import 'package:rp_mobile/layers/services/session.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/utils/future.dart';

class SplashScreenProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<StartupBloc>(
      create: (context) => StartupBloc(GetIt.instance.get<SessionService>())
        ..add(OnStart()),
      child: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<StartupBloc>(context).listen((state)  async {
      await delay(1000);
      handleStartupRouting(context, state);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      theme: AppThemes.splashScreenTheme(),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Image.asset('images/splash_logo.png'),
            ),
            Expanded(
              flex: 1,
              child: SizedBox.shrink(),
            ),
            Text(
              'Explore Russia with RussPass',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 70,
                vertical: 20,
              ),
              child: BlocBuilder<StartupBloc, StartupState>(
                builder: (context, state) {
                  if (state is InitialStartupState) {
                    return _ProgressBar(0);
                  } else if (state is LoadingSession) {
                    return _ProgressBar(50);
                  } else {
                    return _ProgressBar(100);
                  }
                },
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatefulWidget {
  final int percent;

  const _ProgressBar(this.percent, {Key key})
      : assert(percent != null),
        super(key: key);

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<_ProgressBar>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _prepareAnimations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  _prepareAnimations() {
    _animationController = AnimationController(
      vsync: this,
      value: 0.0,
      duration: Duration(milliseconds: 2000),
    );
  }

  @override
  void didUpdateWidget(_ProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animationController.animateTo(
      widget.percent / 100.0,
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 2,
          decoration: BoxDecoration(
            color: const Color(0xFFCB4545),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizeTransition(
          sizeFactor: _animationController,
          axis: Axis.horizontal,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        )
      ],
    );
  }
}
