import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:rp_mobile/layers/bloc/errors/bloc.dart';
import 'package:rp_mobile/layers/drivers/errors.dart';
import 'package:rp_mobile/layers/ui/pages/error/route.dart';
import 'package:rp_mobile/layers/ui/themes.dart';

import 'locale/app_localizations.dart';

Future setUp() async {
  BlocSupervisor.delegate = AppBlocDelegate();
}

class AppBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    debugPrint(event.toString());
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint(transition.toString());
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    GetIt.instance<ErrorsProducer>().pushError(error, stacktrace);
    debugPrint(error.toString());
    debugPrint(stacktrace.toString());
  }
}

class RussPassApp extends StatefulWidget {
  final Widget home;

  const RussPassApp({
    Key key,
    @required this.home,
  }) : super(key: key);

  @override
  _RussPassAppState createState() => _RussPassAppState();
}

class _RussPassAppState extends State<RussPassApp> {
  final _key = ErrorHandlerKey();
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _bloc = ErrorsBloc();

  @override
  void initState() {
    super.initState();

    GetIt.instance<ErrorsProducer>().registerErrorHandler(
      _key,
      (error, stackTrace) {
        _bloc.add(OnError(error, stackTrace));
        _navigatorKey.currentState.push(ErrorPageRoute());
        return false;
      },
    );
  }

  @override
  void dispose() {
    GetIt.instance<ErrorsProducer>().unregisterErrorHandler(_key);
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ErrorsBloc>(
      create: (context) => _bloc,
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        onGenerateTitle: (BuildContext context) =>
            AppLocalizations.of(context).title,
        localizationsDelegates: [
          const AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'),
          const Locale('ru'),
        ],
        theme: AppThemes.materialAppTheme(),
        home: widget.home,
      ),
    );
  }
}
