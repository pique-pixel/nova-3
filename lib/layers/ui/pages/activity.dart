import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/widgets/base/fade_background.dart';
import 'package:rp_mobile/layers/ui/widgets/base/scroll_behavior.dart';
import 'package:rp_mobile/layers/ui/widgets/base/bottom_nav_bar.dart';
import 'dart:math' as math;

import 'package:yandex_mapkit/yandex_mapkit.dart';

class ActivityPage extends StatelessWidget {
  static route(titlePage,addressPage, imagePage,descriptionPage,latPage,lonPage) => MaterialPageRoute(builder: (context) =>
      ActivityPage(
          title: titlePage,
          address: addressPage,
          image: imagePage,
          description: descriptionPage,
          lat: latPage,
          lon: lonPage
      ));

  final String title;
  final String address;
  final ImageProvider image;
  final String description;
  final double lat;
  final double lon;

  const ActivityPage({
    Key key,
    @required this.title,
    @required this.address,
    @required this.image,
    @required this.description,
    @required this.lat,
    @required this.lon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      theme: AppThemes.pageBrightnessLightTheme(),
      body: SafeArea(
        child: Scaffold(
        bottomNavigationBar: BottomNavBar(index: 1),
    body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: CustomScrollView(
          physics: ClampingScrollPhysics(),
          slivers: <Widget>[
            _Header(title:title,image:image),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    color: AppColors.primaryRed,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18.0,
                            vertical: 6,
                          ),
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: NamedFontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Wrap(
                            children: <Widget>[
                              _Tag('музей'),
                              _Tag('рекомендация'),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Text(
                            address,
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Text(
                            'Официальный сайт',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: NamedFontWeight.semiBold,
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        _InfoBarSpoiler(
                          title: 'Режим работы',
                          icon: Icons.event,
                          data: 'Пн, Чт-Сб: 10.00 - 17.30\n'
                              'Вт: 10.00 - 16.30\n'
                              'Вс: 11.00 - 17.30\n'
                              'Ср - выходной',
                        ),
                        /*_InfoBarSpoiler(
                          title: 'Режим работы',
                          icon: Icons.event,
                          data: 'Пн, Чт-Сб: 10.00 - 17.30\n'
                              'Вт: 10.00 - 16.30\n'
                              'Вс: 11.00 - 17.30\n'
                              'Ср - выходной',
                        ),*/
                        _InfoBar(
                          title: 'Тариф Взрослый',
                          value: _Time('≈ 5 ч 30 м'),
                        ),
                      ],
                    ),
                  ),
                  _Map(latitude:lat,longitude:lon),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 21, 18, 8),
                    child: Text(
                        description,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final ImageProvider image;
  const _Header({
    Key key,
    @required this.title,
    @required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 106,
        maxHeight: 296.0,
        child: Container(
          color: AppColors.primaryRed,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: FadeBackgroundImage(
                    image,
//                  CachedNetworkImageProvider(image),
                  backgroundColor: Color(0xFFD8D8D8),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
              SizedBox(
                height: 96,
                child: SafeArea(bottom: false, child: _AppBar(title:title)),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Time extends StatelessWidget {
  final String time;

  const _Time(this.time, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(Icons.access_time, size: 16, color: Colors.white),
        SizedBox(width: 5),
        Text(time, style: TextStyle(color: Colors.white)),
      ],
    );
  }
}

class _InfoBar extends StatelessWidget {
  final String title;
  final Widget value;

  const _InfoBar({
    Key key,
    @required this.title,
    @required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                title,
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
            ),
          ),
          value,
          SizedBox(width: 20),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;

  const _Tag(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class _AppBar extends StatelessWidget {
  final String title;
  const _AppBar({
    Key key,
    @required this.title,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: Material(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(height: 6),
                  _BackButton(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                    ),
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: NamedFontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
//            Expanded(child: SizedBox.shrink()),
            _Avatar(),
            SizedBox(width: 18),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: MaterialLocalizations.of(context).backButtonTooltip,
      child: InkWell(
        onTap: () {
          Navigator.maybePop(context);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 0, 4, 0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: IconTheme.merge(
                    data: IconThemeData(
                      color: Color(0xFFFF2D55),
                    ),
                    child: const BackButtonIcon(),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Text(
                'вернуться к списку',
                style: TextStyle(
                  color: Color(0xFFFF2D55),
                  fontSize: 17,
                ),
              ),
              SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 51,
      height: 51,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFD8D8D8),
        image: DecorationImage(
          image: AssetImage('images/avatar.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _InfoBarSpoiler extends StatefulWidget {
  final String title;
  final IconData icon;
  final String data;

  const _InfoBarSpoiler({
    Key key,
    this.title,
    this.icon,
    this.data,
  }) : super(key: key);

  @override
  _InfoBarSpoilerState createState() => _InfoBarSpoilerState();
}

class _InfoBarSpoilerState extends State<_InfoBarSpoiler>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  AnimationController _animation;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 0.0,
    );
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 56,
          child: Material(
            color: AppColors.primaryRed,
            child: InkWell(
              highlightColor: Colors.white24,
              splashColor: Colors.white30,
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                  _updateAnim();
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(widget.icon, color: Colors.white),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                    RotatedBox(
                      quarterTurns: _isExpanded ? 1 : 3,
                      child: Icon(Icons.chevron_left, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 1,
          color: Color(0xffd34047),
        ),
        SizeTransition(
          axisAlignment: 0.0,
          sizeFactor: _animation,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
            color: Color(0xffeb474f),
            child: Text(
              widget.data,
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
        ),
      ],
    );
  }

  void _updateAnim() {
    _animation.fling(velocity: _isExpanded ? 1.0 : -1.0);
  }
}

class _Map extends StatelessWidget {
  final double latitude;
  final double longitude;

  const _Map({
    Key key,
    @required this.latitude,
    @required this.longitude,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 142,
      width: double.infinity,
      child: YandexMap(
        onMapCreated: (controller) async {
          await controller.setBounds(
            southWestPoint: Point(
              latitude: latitude - 0.02,
              longitude: longitude - 0.02,
            ),
            northEastPoint: Point(
              latitude: latitude + 0.02,
              longitude: longitude + 0.02,
            ),
          );
        },
      ),
    );
  }
}
