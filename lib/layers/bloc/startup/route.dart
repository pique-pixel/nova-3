import 'package:flutter/widgets.dart';
import 'package:rp_mobile/layers/bloc/startup/startup_state.dart';
import 'package:rp_mobile/layers/ui/pages/auth/auth.dart';
import 'package:rp_mobile/layers/ui/pages/favourites/favourites_page.dart';
import 'package:rp_mobile/layers/ui/pages/tips.dart';

handleStartupRouting(BuildContext context, StartupState state) async {
  if (context == null) return;
  if (state is RouteDashboardState) {
    Navigator.of(context).pushReplacement(FavouritesPage.route());
  } else if (state is RouteWelcomeState) {
    Navigator.of(context).pushReplacement(Auth.route());
  } else if (state is RouteTipsState) {
    Navigator.of(context).pushReplacement(TipsPage.route());
  }
}
