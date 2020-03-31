import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/widgets/base/bottom_nav_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rp_mobile/layers/services/session.dart';
import 'package:rp_mobile/layers/bloc/explorer/bloc.dart';
import 'package:rp_mobile/layers/ui/pages/favourites/favourites_page.dart';
import 'package:rp_mobile/layers/ui/pages/routes/routes.dart';
import 'package:rp_mobile/layers/ui/pages/plan/plans.dart';
import 'package:rp_mobile/layers/ui/pages/faq.dart';

class ExplorerPageProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExplorerBloc>(
      create: (context) {
        return ExplorerBloc(GetIt.instance<SessionService>())..add(OnLoad());
      },
      child: ExplorerPage(),
    );
  }
}

class ExplorerPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => ExplorerPageProvider());

  @override
  _ExplorerPageState createState() => _ExplorerPageState();
}

class _ExplorerPageState extends State<ExplorerPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  String _url = 'https://explore.dev.russpass.ru/';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      theme: AppThemes.materialAppTheme(),
      bottomNavigationBar: BottomNavBar(index: BottomNavPageIndex.explorer),
      body: BlocBuilder<ExplorerBloc, ExplorerState>(
        builder: (context, state) {
          if (state is LoadedSessionState) {
            if (state.session.isPresent) {
              final session = state.session.value;
              _url =
                  '$_url?access_token=${session.accessToken}&refresh_token=${session.refreshToken}&expires_in=1199';
            }
            return WebView(
              initialUrl: _url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              navigationDelegate: (NavigationRequest request) {
                if (request.url.startsWith("russpass://")) {
                  RegExp exp = new RegExp(r"(russpass://)");
                  String str = request.url;
                  String res = str.replaceAll(exp, '');
                  switch (res) {
                    case "favourites":
                      Navigator.of(context)
                          .pushReplacement(FavouritesPage.route());
                      break;
                    case "plan":
                      Navigator.of(context).pushReplacement(PlansPage.route());
                      break;
                    case "map":
                      Navigator.of(context).pushReplacement(RoutesPage.route());
                      break;
                    case "faq":
                      Navigator.of(context).pushReplacement(FaqPage.route());
                      break;
                  }
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
