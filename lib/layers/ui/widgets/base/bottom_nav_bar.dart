import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/pages/explorer.dart';
import 'package:rp_mobile/layers/ui/pages/favourites/favourites_page.dart';
//TODO real data
//import 'package:rp_mobile/layers/ui/pages/tickets/tickets.dart';
//TODO demo data
import 'package:rp_mobile/layers/ui/pages/tickets/tickets_demo.dart';
import 'package:rp_mobile/layers/ui/pages/plan/plans.dart';
import 'package:rp_mobile/layers/ui/pages/profile_group/profile.dart';
//import 'package:rp_mobile/layers/ui/pages/faq.dart';

class BottomNavPageIndex {
  static const explorer = 0;
  static const dashboard = 1;
  static const plan = 2;
  static const favourites = 3;
  static const ticket = 4;
  static const map = 5;
  static const faq = 6;
  static const profile = 7;
}

class BottomNavBar extends StatefulWidget {
  final index;

  const BottomNavBar({Key key, @required this.index}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState(index);
}

class _BottomNavBarState extends State<BottomNavBar> {
  final int index;

  _BottomNavBarState(this.index);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(6.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(ExplorerPage.route());
              },
              icon: index == BottomNavPageIndex.explorer
                  ? Image.asset(
                      'images/location_active.png',
                      width: 26,
                      height: 26,
                    )
                  : Image.asset(
                      'images/location.png',
                      width: 26,
                      height: 26,
                    ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(6.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(FavouritesPage.route());
              },
              icon: index == BottomNavPageIndex.favourites
                  ? Image.asset(
                      'images/favorite_active.png',
                      width: 26,
                      height: 26,
                    )
                  : Image.asset(
                      'images/favorite.png',
                      width: 26,
                      height: 26,
                    ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(6.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(PlansPage.route());
              },
              icon: index == BottomNavPageIndex.plan
                  ? Image.asset(
                      'images/route_active.png',
                      width: 26,
                      height: 26,
                    )
                  : Image.asset(
                      'images/route.png',
                      width: 26,
                      height: 26,
                    ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(6.0),
            child: IconButton(
              onPressed: () {
                //TODO real data
//                Navigator.of(context).pushReplacement(TicketsPage.route());
                //TODO demo data
                Navigator.of(context).pushReplacement(TicketsDemoPage.route());
              },
              icon: index == BottomNavPageIndex.ticket
                  ? Image.asset(
                'images/plan_active.png',
                width: 26,
                height: 26,
              )
                  : Image.asset(
                'images/plan.png',
                width: 26,
                height: 26,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(6.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(ProfilePage.route());
              },
              icon: index == BottomNavPageIndex.profile
                  ? Image.asset(
                      'images/profile_active.png',
                      width: 26,
                      height: 26,
                    )
                  : Image.asset(
                      'images/profile.png',
                      width: 26,
                      height: 26,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
